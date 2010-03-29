=begin

This is a collection of modifications to SafariWatir to get it to work more consistently with the
Watir API

=end

if $browserName and $browserName.downcase == 'safari'

require 'safariwatir'

module Watir
  module Container
    # Implement missing API method - all text fields
    def text_fields()
      return @scripter.get_all_text_fields
    end
    
    # Implement missing API method - all elements matching an xpath
    def elements_by_xpath(xpath)
      return @scripter.get_all_by_xpath(xpath)
    end
    
    class HtmlElement
      # Implement missing API methods - id, for, and name on all HTML elements
      def id
        return attr('id') || ''
      end
      def for
        return attr('for') || ''
      end
      # This htmlname rather than name because name seems to have a special meaning in some versions of Ruby.
      def htmlname
        return @scripter.get_attribute('name', self) || ''
      end
      def value
        return @scripter.get_value_for(self) || ''
      end

      # Implement missing API method - is the element visible?
      def visible?
        return @scripter.eval_on_element("return (function(el) {
          while(el && el != document) {
            var s = window.getComputedStyle(el, null);
            if(s.getPropertyValue('display') == 'none' || s.getPropertyValue('visibility') == 'hidden') return false;
            el = el.parentNode;
          }; 
          return true;
        })(element);", self)
      end
    end
    
    class TextField
      # Altered API method for consistency - char-by-char setting of the value mucked with onchange
      # handlers
      def set(value)
        @scripter.focus(self)
        @scripter.highlight(self) do
          clear_text_input
          append_text_input(value.to_s)
        end
        @scripter.blur(self)
      end
    end
  end
  
  class Safari
    # Added missing API method - evaluate an arbitrary script
    def evaluate_script(script)
      return @scripter.evaluate_script(script)
    end

				def attach(how, what)
					return @scripter.attach(how, what)
				end
  end
  
  class AppleScripter

				def click_link(element = @element)
					click = %/
function baseTarget() {
  var bases = document.getElementsByTagName('BASE');
  if (bases.length > 0) {
    return bases[0].target;
  } else {
    return;
  }
}
function undefinedTarget(target) {
  return target == undefined || target == '';
}
function topTarget(target) {
  return undefinedTarget(target) || target == '_top';
}
function blankTarget(target) {
	return target == '_blank'
}
function nextLocation(element) {
  var target = element.target;
  if (undefinedTarget(target) && baseTarget()) {
    top[baseTarget()].location = element.href;
  } else if (topTarget(target)) {
    top.location = element.href;
  } else if (blankTarget(target)) {
		top[target] = window.open(element.href)
  } else {
    top[target].location = element.href;
  }
}
var click = DOCUMENT.createEvent('HTMLEvents');
click.initEvent('click', true, true);
if (element.onclick) {
 	if (false != element.onclick(click)) {
		nextLocation(element);
	}
} else {
	nextLocation(element);
}/
					page_load do
						execute(js.operate(find_link(element), click))
					end
				end

				def attach(how, what)
					doc = nil
					docs = @app.get(@app.documents)
					if how == :url then
						docs.each {|d| if @app.get(d.URL) == what then doc=d; break; end }
					else
						docs.each {|d| if @app.get(d.name) == what then doc=d; break; end }
					end
					print "Doc = #{doc}\n"
					if doc then
						@document = doc
					end
				end

    # Internal handler for Safari class to access
    def evaluate_script(script)
      return execute(script)
    end

    # Internal handler for Safari class to access
    def get_all_text_fields()
      ids = get_ids_from_js("document.getElementsByTagName('input')", "item.type == 'text' || item.type == 'password'") + get_ids_from_js("document.getElementsByTagName('textarea')")
      return ids.map { |id|
        Container::TextField.new(self, :id, id)
      }
    end
    
    # Internal handler for Safari class to access
    def get_all_by_xpath(xpath) 
      xpath = xpath.gsub("'","\'")
      ids = get_ids_from_js("document.evaluate(\"#{xpath}\", document.documentElement, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null)",
        nil, 
        "items.snapshotLength",
        "items.snapshotItem(i)")
      return ids.map { |id|
        Container::HtmlElement.new(self, :id, id)
      }
    end

    # Return the IDs of the elements returned by the given JS expression
    # js: The JavaScript that returns a list of items
    # filter: The JavaScript to evaluate on each item (variable name will be 'item') to filter the
    # list.  This is optional
    # getLength: Expression to get the length of the JS var 'items'
    # getItem: Expression to get the 'i'th of the JS var 'items'
    def get_ids_from_js(js, filter = nil, getLength = "items.length", getItem = "items[i]")
      if filter == nil
        filter = "true"
      end

      fullJS = <<-eos
        return (function() {
          var items = #{js};
          var i, item;
          var output = [];
          for(i=0;i<#{getLength};i++) {
            item = #{getItem};
            if(#{filter}) {
              // Adding a random ID is a little clumsy but will do, for now
              if(!item.id) item.id = 'safariwatir-' + parseInt(Math.random()*1000000000);
              output.push(item.id);
            }
          }
          return output;
        })()
        eos
        
      return eval_js(fullJS)
    end
    
    # Internal handler for HtmlElement class - Evaluate JS on a particular element
    def eval_on_element(js, element)
      execute(element.operate { js }, element)
    end
    
    # Altered API methdo - fix bugs in match by ID and Value
    def handle_match(element, how = nil)
      how = {:text => "text", :url => "href", :id => 'id', :value => 'value', :xpath => 'xpath'}[element.how] unless how
      case element.what
        when Regexp
          %|#{how}.match(/#{element.what.source}/#{element.what.casefold? ? "i":nil})|          
        when String
          %|#{how} == '#{element.what}'|
        else
          raise RuntimeError, "Unable to locate #{element.element_name} with #{element.how}"
      end
    end    
  
    # Altered internal API method - need to wait for the URL displayed to actually change, so that
    # we can handle slow-loading pages better
    def navigate_to(url, &extra_action)
      page_load(extra_action) do
        currentURL = @document.URL.get
        @document.URL.set(url)
        
        if currentURL != url
          60.times do |tries|
            if @document.URL.get != currentURL
              break
            else
              sleep 0.5
            end
          end
        end
      end
    end

  end
end

end