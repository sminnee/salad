# This is a stub class for defining the version
# In time, the non-Watir ruby code that the step definitions make use of can be moved into this.
module Salad
  class Salad
    VERSION = "0.1.4"

		def initialize(browser)
			@browser = browser
		end

    	def browser()
      		return @browser
    	end
    
		# Get an attribute of an element
		# Handles the differing behaviour between Watir, SafariWatir, and FireWatir
		def getAttribute(element, attrName)
			if attrName == 'for' then ieAttrName = 'htmlFor'
			elsif attrName == 'class' then ieAttrName = 'className'
			else ieAttrName = attrName end

			if element.respond_to?('attr') then return element.attr(attrName)
			elsif element.respond_to?('attribute_value') then return element.attribute_value(ieAttrName)
			else return element.getAttribute(ieAttrName)
			end
		end

		# => is a checkbox checked or not?
		def isChecked?(element)
			isChecked = false
			if element.respond_to?(:checked?) then
				isChecked = element.checked?
			elsif element.respond_to?(:checked) then
				isChecked = element.checked
			end
			return isChecked
		end

		# Try to find control by its label
		# and then use the optional create block to create it
		# @usage
		#		item = @salad.byLabel(match) {|id| @browser.select_list(:id, id)}
		# @usage
		#		itemid = @salad.byLabel(match)
	  # => element or element_id
		def byLabel(value, &create)
			label = @browser.label(:text, value)
			item = nil
			if label.exists? then
				itemid = self.getAttribute(label, 'for')
				if create then
					item = create.call(itemid)
				else
					return itemid
				end
			else
				print "Failed to find label '#{value}'\n"
			end
			return item
		end

		# Selected options from a select_list, cross browser
		# => array of options
		def selected_options(element)
			if element.respond_to?(:selected_options) then
				return element.selected_options
			elsif element.respond_to?(:selected_values) then
				return element.selected_values
			else
				print element.inspect(), "\n"
				fail("Didn't respond to anything")
			end
			return []
		end


		# Portable script evaluation
		def evaluate_script(browser, js)
			if browser.respond_to?('execute_script') and not browser.instance_of?(FireWatir::Firefox)
				browser.execute_script("(function() { #{js} })()")
			else
				browser.evaluate_script(js)
			end
		end

		# Portable script evaluation, with return value.
		def evaluate_script_return(browser, js)
			if browser.respond_to?('execute_script') and not browser.instance_of?(FireWatir::Firefox)
				browser.execute_script("(function() { return #{js} })()")
			else
				browser.evaluate_script("return #{js}")
			end
		end

		# => Portable return of current URL
		def url()
			return self.evaluate_script_return(@browser, 'window.location.href')
		end

		# => Portably attach to another browser window
		def attach(how, what)
      puts "Salad::attach(#{how}, #{what})"
			begin
				if defined?(Watir::IE) and @browser.instance_of?(Watir::IE) then
					# do it the hard way
					begin
						win = Watir::IE.attach(how, /#{what}/)
						win = Watir::IE.attach(how, what) unless win
					rescue Watir::Exception::NoMatchingWindowFoundException
						win = nil
					end
					return nil unless win
					@browser = win
				end
			rescue NameError,MissingSourceFile
				# Assuming these are from IE missing errors above.
			end

      begin
        win = @browser.attach(how, /#{what}/) unless win
        puts "Attached using #{how} and /#{what}/" if win
      rescue Watir::Exception::NoMatchingWindowFoundException
        win = nil
      end
      unless win
        begin
          win = @browser.attach(how, what) unless win
          puts "Attached using #{how} and '#{what}'" if win
        rescue Watir::Exception::NoMatchingWindowFoundException
          win = nil
        end
      end
      unless win
        begin
          what = Regexp.quote(what)
          win = @browser.attach(how, /#{what}/) unless win
          puts "Attached using #{how} and quoted /#{what}/" if win
        rescue Watir::Exception::NoMatchingWindowFoundException
          win = nil
        end
      end
			return win
		end

  end # class Salad
end # module Salad