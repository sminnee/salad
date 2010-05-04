# This is a stub class for defining the version
# In time, the non-Watir ruby code that the step definitions make use of can be moved into this.
module Salad
	class Salad
		VERSION = "0.1.5"
		DEBUG = false
		
		def debug(str)
			if $DEBUG then
				puts(str)
			end
		end
		
		# Initialise Salad with a browser object.
		def initialize(browser)
			@browser = browser
		end

		# Getter for current @browser
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
			method = @browser.method(type);
			hows.each {|how|
				self.debug(":how = #{how}")
				if how == :index and not what.is_a?(Numeric) then next end
				if how == :label then
					self.debug("Trying label")
					elt = self.byLabel(what) {|id| method.call(:id, id)}
					if elt and elt.exists? and elt.visible? then
						return elt
					end
					next
				end
				self.debug("Try Create, using #{how} #{what}")
				elt = method.call(how, what)
				if elt and elt.exists? and elt.visible? then
					break
				end
			}
			# Try to find control by its label
			if not (elt and elt.exists? and elt.visible?) then
			end

			elt = nil unless elt.exists? and elt.visible?
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
			label = @browser.label(:text, value)
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

		# Portable return of current URL
		def url()
			return self.evaluate_script_return(@browser, 'window.location.href')
		end

		# Portably attach to another browser window
		# how is :url or :title
		# what is the content to match. may be a regex?
		def attach(how, what)
			self.debug("Salad::attach(#{how}, #{what})")
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
				#puts "Attached using #{how} and /#{what}/" if win
			rescue Watir::Exception::NoMatchingWindowFoundException
				win = nil
			end
			unless win
				begin
					win = @browser.attach(how, what) unless win
					#puts "Attached using #{how} and '#{what}'" if win
				rescue Watir::Exception::NoMatchingWindowFoundException
					win = nil
				end
			end
			unless win
				begin
					what = Regexp.quote(what)
					win = @browser.attach(how, /#{what}/) unless win
					#puts "Attached using #{how} and quoted /#{what}/" if win
				rescue Watir::Exception::NoMatchingWindowFoundException
					win = nil
				end
			end
			return win
		end # attach()


		def getSelectList(match)
			item = @browser.select_list(:id, match)
			item = @browser.select_list(:name, match) unless item and item.exists? and item.visible?
			#  item = browser.select_list(:xpath, match) unless item and item.exists? and item.visible?

			# Try to find control by its label
			if not (item.exists? and item.visible?) then
				label = @browser.label(:text, match)
				if label.exists? then
					itemid = self.getAttribute(label, 'for')
					item = @browser.select_list(:id, itemid)
				end
			end

			if not item.exists? and item.visible? then item = nil end
			return item
		end

		# Try running with the text_field ":id", ":name", ":value", ":index" or ":class" element attribute.
		# Does not matter what you select!
		# The proper watir code will be executed regardless.
		def getTextField(type)
			# Build an array of all potential fields
			fields = []
			# By ID
			@browser.text_fields().each { | field |
				if field.id == type then fields.push field end
			}
			# By Name
			@browser.text_fields().each { | field |
				if field.respond_to?('htmlname') then
					if field.htmlname == type then fields.push field end
				else
					if field.name == type then fields.push field end
				end
			}
			# By the associated <label>
			matchingLabels = @browser.elements_by_xpath("//label[.='#{type}']")
			if matchingLabels then
				matchingLabels.each { | label |
					labelFor = self.getAttribute(label, 'for')

					if labelFor then
						@browser.text_fields().each { | field |
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
			return self.getElement('radio', what, [:id, :name, :value, :text, :index, :class])
		end


		def getLink(match)
			link = @browser.link(:id, match)
			if not link.exists? then link = @browser.link(:text, match) end
			if not link.exists? then link = @browser.link(:class, match) end
			# Try the URL with both the baseURL prefix and without it
			if not link.exists? then link = @browser.link(:url, @baseURL + match) end
			if not link.exists? then link = @browser.link(:url, match) end
			if not link.exists? then link = @browser.link(:xpath, match) end
			if not link.exists? then link = nil end
			return link
		end

		def getCheckbox(what)
			return self.getElement('checkbox', what, [:id,:name,:value,:text,:index,:class])
		end


		def getButton(type)
			button = @browser.button(:id, type)
			button = @browser.button(:value, type) unless button.exists? and button.visible?

			# :text used for Firefox suport
			if @browser.instance_of?(FireWatir::Firefox)
				button = @browser.button(:text, type) unless button.exists? and button.visible?
			end
			# :xpath used for Safari suport
			button = @browser.button(:xpath, "//button[.='#{type}']") unless button.exists? and button.visible?

			button = @browser.button(:index, type) unless button.exists? and button.visible?
			button = @browser.button(:class, type) unless button.exists? and button.visible?

			button = nil unless button.exists? and button.visible?
			return button
		end

		def getImage(what)
			return self.getElement('image', what, [:src,:id,:name,:text,:index,:class])
		end
	end # class Salad
end # module Salad
