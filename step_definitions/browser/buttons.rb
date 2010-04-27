# Try running with the button ":id", ":name", ":value", ":text", ":index" or ":class" element attribute.
# Does not matter what you select!
# The proper watir code will be executed regardless.

Given /click the "(.*)" button/i do |which|
  btn = getButton(@salad.browser, which)
  
  if(btn) then
    ajax_before_action @salad.browser
    btn.click
    ajax_after_action @salad.browser
  else
    fail("could not find the '#{which}' button on #{@salad.browser.url}")
  end
end

def getButton(browser, what)
	field_elt = nil
	hows = [:id, :name, :value, :index, :class]

	hows.each {|how|
		if how == :index and not what.is_a?(Numeric) then next end
		field_elt = browser.button(how, what)
		if field_elt and field_elt.exists? and field_elt.visible? then
			return field_elt
		end
	}
	# :text used for Firefox suport
	if browser.instance_of?(FireWatir::Firefox)
		field_elt = browser.button(:text, what)
		return field_elt if field_elt and field_elt.exists? and field_elt.visible?
	end
	# Try to find control by XPath (safari support)
	if not (field_elt and field_elt.exists? and field_elt.visible?) then
		xpath = "//button[.=\"#{what}\"]"
		field_elt = browser.button(:xpath, xpath)
		return field_elt if field_elt and field_elt.exists? and field_elt.visible?
	end
	# Try to find control by its label
	if not (field_elt and field_elt.exists? and field_elt.visible?) then
		field_elt = @salad.byLabel(what) {|id| @salad.browser.button(:id, id)}
	end

	field_elt = nil unless field_elt and field_elt.exists? and field_elt.visible?
	return field_elt
end
