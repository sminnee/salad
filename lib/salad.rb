# This is a stub class for defining the version
# In time, the non-Watir ruby code that the step definitions make use of can be moved into this.
module Salad
  class Salad
    VERSION = "0.1.4"

		def initialize(browser)
			@browser = browser
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

		def isChecked(element)
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
		#
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

		def evaluate_script_return(browser, js)
			if browser.respond_to?('execute_script') and not browser.instance_of?(FireWatir::Firefox)
				browser.execute_script("(function() { return #{js} })()")
			else
				browser.evaluate_script("return #{js}")
			end
		end

		def url(browser)
			return self.evaluate_script_return(browser, 'window.location.href')
		end
  end
end
