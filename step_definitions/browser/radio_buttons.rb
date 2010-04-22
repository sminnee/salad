# Try running with the radio ":id", ":name", ":value", ":text", ":index" or ":class" element attribute.
# Does not matter what you select!
# The proper watir code will be executed regardless.

Given /click the "(.*)" radio button/i do |type|
	elt = getRadioButton(type)
	if elt then
		elt.click
	else
		fail("could not find what you asked for")
	end
end

Given /radio button "(.*)" is(\s+not)? selected/i do |field, wantUnchecked|
	Given "\"#{field}\" radio button is#{wantUnchecked} selected"
end

Given /"(.*)" radio button is(\s+not)? selected/i do |field, wantUnchecked|
	radioButton = getRadioButton(field)
	wantUnchecked = (wantUnchecked != nil)
	if radioButton then
		isChecked = @salad.isChecked?(radioButton)
		if wantUnchecked then
			fail("The radio button #{field} was selected") if isChecked
		else
			fail("The radio button #{field} was not selected") if not isChecked
		end
	else
		fail("could not find what you asked for")
	end
end



def getRadioButton(what)
	return @salad.getElement(what) {|how,what| @salad.browser.radio(how, what)}
end