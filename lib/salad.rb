# This is a stub class for defining the version
# In time, the non-Watir ruby code that the step definitions make use of can be moved into this.
module Salad
	class Salad
		VERSION = "0.1.6"
		@@DEBUG = false
		
		def debug(str)
			if @@DEBUG
				puts("\t" + str)
			end
		end

    def setNextContainer(elt)
      self.debug("setNextContainer (was #{@container.inspect}) => #{elt.inspect}")
      @container = elt
    end

    def resetContainer()
      @container = @browser
      @mainWindow.use
      self.debug("resetContainer => #{@container.inspect}")
    end

		def setDebug(turnOn)
			@@DEBUG = turnOn
		end
		
		# Initialise Salad with a browser object.
		def initialize(browser, baseURL)
			@browser = browser
			@baseURL = baseURL

      @browser.windows.each { |win| 
        if win.current? then
          @mainWindow = win
          break
        end
      }

      self.setNextContainer(@browser)
		end

		# Getter for current @browser
		def browser()
			return @browser
		end

		def container()
			return @container
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

		# Determine if a checkbox is checked or not?
		def isChecked?(element)
			isChecked = false
			if element.respond_to?(:checked?) then
				isChecked = element.checked?
			elsif element.respond_to?(:checked) then
				isChecked = element.checked
			end
			return isChecked
		end


		# Portable getElement function.
		# Usage: getElement('button', 'Item one', [:name, :id, :class, ...])
		def getElement(type, what, hows=nil, &createFn)
			elt = nil
			if hows == nil then
				hows = [:id, :name, :value, :label, :index, :class]
			end
      self.debug("getElement(#{type}, #{what}, #{hows.join(', ')})")
			method = @container.method(type);
			hows.each {|how|
				self.debug("getElement(#{type}, #{what}), trying #{how}...")
				if how == :index and not what.is_a?(Numeric) then next end
				if how == :label then
					self.debug("getElement(#{type},#{what}), trying :label...")
					elt = self.byLabel(what) {|id| method.call(:id, id)}
					if elt and elt.exists? and elt.visible? then
						self.debug("===> #{elt}")
						return elt
					end
					next
				end
				self.debug("getElement(#{type},#{what}), test #{method.to_s}(#{how}, #{what})...")
				elt = method.call(how, what)
				if elt and elt.exists? and elt.visible? then
					break
				end
			}

			elt = nil unless elt and elt.exists? and elt.visible?
			self.debug("===> #{elt}")
			return elt
		end
		# Try to find control by its label
		# and then use the optional create block to create it
		# Usage
		#		item = @salad.byLabel(match) {|id| @browser.select_list(:id, id)}
		# or:
		#		itemid = @salad.byLabel(match)
		# Returns: element or element_id
		def byLabel(value, &create)
			label = @container.label(:text, value)
			item = nil
			if label.exists? then
				itemid = self.getAttribute(label, 'for')
				if create then
					item = create.call(itemid)
				else
					return itemid
				end
#			else
#				print "Failed to find label '#{value}'\n"
			end
			return item
		end

		# Selected options from a select_list, cross browser
		# returns an array of options
		def selected_options(element)
			if element.respond_to?(:selected_options) then
        self.debug(element.method('selected_options').inspect)
        return element.selected_options
			elsif element.respond_to?(:selected_values) then
        self.debug(element.method('selected_values').inspect)
				return element.selected_values
			else
				print element.inspect(), "\n"
				fail("Didn't respond to anything")
			end
			return []
		end


		# Portable script evaluation
		def evaluate_script(browser, js)
				browser.execute_script("(function() { #{js} })()")
		end

		# Portable script evaluation, with return value.
		def evaluate_script_return(browser, js)
	      browser.execute_script("return (function() { return #{js} })()")
		end

		# Portable return of current URL
		def url()
			return self.evaluate_script_return(@browser, 'window.location.href')
		end

		# Portably attach to another browser window
		# how is :url or :title
		# what is the content to match. may be a regex?
		def attach(how, what)
			self.debug("Salad::attach(#{how}, #{what})")
			win = nil
			begin
    		  win = @browser.window(how, what)
    		  win.use
			rescue NameError,MissingSourceFile,NoMatchingWindowFoundException
			end
			
			return win
		end # attach()


		def getSelectList(match)
			item = @container.select_list(:id, match)
			item = @container.select_list(:name, match) unless item and item.exists? and item.visible?
			#  item = browser.select_list(:xpath, match) unless item and item.exists? and item.visible?

			# Try to find control by its label
			if not (item.exists? and item.visible?) then
				label = @container.label(:text, match)
				if label.exists? then
					itemid = self.getAttribute(label, 'for')
					item = @container.select_list(:id, itemid)
				end
			end

			if item and not (item.exists? and item.visible?) then
				item = nil
			end
			return item
		end

		# Try running with the text_field ":id", ":name", ":value", ":index" or ":class" element attribute.
		# Does not matter what you select!
		# The proper watir code will be executed regardless.
		def getTextField(type)
			# Build an array of all potential fields
			fields = []
			# By ID
			@container.text_fields().each { | field |
				if field.id == type then fields.push field end
			}
			# By Name
			@container.text_fields().each { | field |
				if field.respond_to?('htmlname') then
					if field.htmlname == type then fields.push field end
				else
					if field.name == type then fields.push field end
				end
			}
			# By the associated <label>
			matchingLabels = @container.elements_by_xpath("//label[.='#{type}']")
			if matchingLabels then
				matchingLabels.each { | label |
					labelFor = self.getAttribute(label, 'for')

					if labelFor then
						@container.text_fields().each { | field |
							if self.getAttribute(field,'id') == labelFor then fields.push field end
						}
					end
				}
			end

			# Return the first visible one
			fields.each { | field |
				if field.visible? then return field end
			}
			return nil
		end

		def getRadio(what)
      hows = [:id, :name, :text, :value, :index, :class, :label]
			elt = self.getElement('radio', what, hows)
			return elt
		end


		def getLink(match)
			link = self.getElement('link', match, [:id,:text,:class,:href])
			if link then
				return link
			end
			link = self.getElement('link', @baseURL + match, [:href])
			if link then
				return link
			end
			link = self.getElement('link', match, [:label])
			if link then
				return link
			end
		end

		def getCheckbox(what)
      hows = [:id, :name, :text, :value, :index, :class, :label]
			elt = self.getElement('checkbox', what, hows)
			return elt
		end


		def getButton(type)
			hows = [:id,:value,:name,:text]
			elt = self.getElement('button', type, hows)
			if elt then ; return elt; end

			elt = self.getElement('button', type, [:index,:class,:label])
			return elt
		end

		def getImage(what)
      hows = [:src,:id, :index, :class,:label]
      hows.insert(2, :name)
			elt = self.getElement('image', what, hows)
			return elt
		end

		def hasText?(text)
			self.debug('hasText? ' + @container.inspect + ', ' + text)
			return @container.text.include?(text)
		end
		
		def hasHTML?(text)
			self.debug('hasHTML? ' +  @container.inspect + ', ' + text)
			return @container.html.include?(text)
		end
    
	end # class Salad
end # module Salad


def wait_until(&block)
  until result = yield do
    sleep 1
  end
end