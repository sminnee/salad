# Try running with the checkbox  ":id", ":name", ":value", ":text", ":index" or ":class" element attribute.
# Does not matter what you select!
# The proper watir code will be executed regardless.

Given /click the "(.*)" checkbox/i do |type|
	checkbox = getCheckbox(type)
  if checkbox then
		checkbox.click()
	else
    fail("could not find what you asked for")
  end
end

Given /checkbox "(.*)" is(\s+not)? checked/i do |field, wantUnchecked|
	checkbox = getCheckbox(field)
	wantUnchecked = (wantUnchecked != nil)
	if checkbox then
		isChecked = @salad.isChecked?(checkbox)
		if wantUnchecked then
			fail("The checkbox #{field} was checked") if isChecked
		else
			fail("The checkbox #{field} was not checked") if not isChecked
		end
	else
    fail("could not find what you asked for")
	end
end



def getCheckbox(field)
	return @salad.getElement(field) {|how,what| @salad.browser.checkbox(how, what)}
end