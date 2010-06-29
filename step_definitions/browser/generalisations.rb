Given /click "([^"]+)"/ do |what|
	elt = getElementTyped(what, [:Button, :Image, :Link, :Checkbox, :Radio]) {|elt,type,what|
		ajax_before_action @salad.browser
		elt.click
		ajax_after_action @salad.browser
	}
end

Given /I set "([^"]+)" to "([^"]*)"/ do |what, value|
	elt = getElementTyped(what, [:TextField, :SelectList]) {|elt,type,what|
    @salad.debug("Got it, now setting" + [elt,type,what].join(', '))
		if type == :SelectList then
			elt.select(value)
		else
			elt.set(value)
		end
	}
end

Given /"([^"]+)" is(\s+not)? (?:selected|checked)/i do |what, wantUnchecked|
	methods = [:Checkbox, :Radio]
	elt = getElementTyped(what, methods) {|elt,type,what|
		isChecked = @salad.isChecked?(elt)
		if wantUnchecked then
			fail("'#{what}' was checked") if isChecked
		else
			fail("'#{what}' was not checked") if not isChecked
		end
	}
end

Given /"([^"]+)" (?:is|is set to) "([^"]+)"/i do |what, value|
	methods = [:SelectList, :TextField]
	elt = getElementTyped(what, methods) {|elt,type,what|
    @salad.debug("#{elt}, #{type}, #{what}")
		if type == :SelectList then
      @salad.debug( @salad.selected_options(elt).inspect )
			fail("\"#{what}\" was not set to \"#{value}\"") unless @salad.selected_options(elt).index(value)
		else
			elt.value.should == value
		end
	}
end

Given /I inspect "([^"]+)"/ do |what|
	elt = @salad.getElement('frame', what, [:index, :name, :id, :src])
	if elt then
		@salad.setNextContainer(elt)
	else
		fail("Didn't find a frame called #{what}")
	end
end

Given /I inspect the whole page/ do
	@salad.resetContainer()
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
def getElementTyped(what, methods, &action)
	elt = nil
	type = nil
  @salad.debug("getElementTyped(#{what.inspect}, #{methods.inspect}")
	methods.each {|method_name|
		method = @salad.method('get' + method_name.to_s)
		@salad.debug("getElementTyped(#{what}), trying #{method}...")
		elt = method.call(what)
		if elt and elt.exists? and elt.visible? then
			type = method_name
			break
		end
	}
	if elt and elt.visible? and elt.exists? then
		@salad.debug("getElementTyped(#{what}) => Found: \n#{elt.to_s.sub(/^/m, "\t")}\n which is a '#{type}', matched: '#{what}'")
		@salad.debug("action = #{action.inspect}")
    if action.nil? then
      fail("No action specified for getElementTyped(#{what},#{methods})")
    else
      action.call(elt, type, what)
    end
	else
		fail("Unable to find any item matching \"#{what}\" in #{@salad.browser.url}")
	end
end