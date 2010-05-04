Given /click "([^"]+)"/ do |what|
	elt = getElementTyped(what, [:Button, :Image, :Link, :Checkbox, :Radio]) {|elt,type,what,how|
		ajax_before_action @salad.browser
		elt.click
		ajax_after_action @salad.browser
	}
end

Given /I set "([^"]+)" to "([^"]*)"/ do |what, value|
	elt = getElementTyped(what, [:TextField, :SelectList]) {|elt,type,what,how|
		if type == :SelectList then
			elt.select(value)
		else
			elt.set(value)
		end
	}
end

Given /"([^"]+)" is(\s+not)? (?:selected|checked)/i do |what, wantUnchecked|
	methods = [:Checkbox, :Radio]
	elt = getElementTyped(what, methods) {|elt,type,what,how|
		isChecked = @salad.isChecked?(elt)
		if wantUnchecked then
			fail("'#{what}' was checked") if isChecked
		else
			fail("'#{what}' was not checked") if not isChecked
		end
	}
end

Given /"([^"]+)" (?:is|is set to) "([^"]+)"/i do |what, value|
	methods = [:SelectList,:TextField]
	elt = getElementTyped(what, methods) {|elt,type,what,how|
		if type == :SelectList then
			fail("\"#{what}\" was not set to \"#{value}\"") unless @salad.selected_options(elt).index(value)
		else
			elt.value.should == value
		end
	}
end

# Retrieve an element, trying the various _hows_ in order
# and using the various _methods_ to try and create the element.
# If successful, the code block _action_ will be executed, with the arguments:
#	element - the element object
#	type - the name of the method from _methods_ that succeeded
#	how - the _how_ used to find the element (eg: :text, :id, :class, etc)
#   what - what you were looking for
# Example:
#
#   getElementTyped('First name', [:text_field, :select_list, :textarea], [:id, :label, :text])
#		{|element, type, how, what|
#			puts("Found #{element} which is a #{type}, by matching #{how} against #{what}")
#		}
#
def getElementTyped(what, methods, hows=nil, &action)
	elt = nil
	how = nil
	type = nil
	methods.each {|method_name|
		method = @salad.method('get' + method_name.to_s)
		@salad.debug("--- Try #{method}")
		elt = method.call(what)
		if elt and elt.exists? and elt.visible? then
			type = method_name
			break
		end
	}
	if elt and elt.visible? and elt.exists? then
		@salad.debug("Found {#{elt}} which is a '#{type}', by matching the '#{how}' against '#{what}'")
		action.call(elt, type, what, how)
	else
		fail("Unable to find any item matching \"#{what}\" in #{@salad.browser.url}")
	end
end