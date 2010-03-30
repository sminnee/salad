# Try running with the checkbox  ":id", ":name", ":value", ":text", ":index" or ":class" element attribute.
# Does not matter what you select!
# The proper watir code will be executed regardless.

Given /click the "(.*)" checkbox/i do |type|
	checkbox = getCheckbox(@browser, type)
  if checkbox then
		checkbox.click()
	else
    fail("could not find what you asked for")
  end
end

Given /checkbox "(.*)" is(\s+not)? checked/i do |field, wantUnchecked|
	checkbox = getCheckbox(@browser, field)
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

def getCheckbox(browser, field)
	field_elt = nil
	hows = [:id, :name, :value, :index, :class]

	hows.each {|how|
		if how == :index and not field.is_a?(Numeric) then next end
		field_elt = browser.checkbox(how, field)
		if field_elt and field_elt.exists? and field_elt.visible? then
			break
		end
	}
	# Try to find control by its label
	if not (field_elt and field_elt.exists? and field_elt.visible?) then
		field_elt = @salad.byLabel(field) {|id| @browser.checkbox(:id, id)}
	end

	field_elt = nil unless field_elt.exists? and field_elt.visible?
	return field_elt
end