# Try running with the link ":id", ":text", ":class" element attribute.
# Does not matter what you select!
# The proper watir code will be executed regardless.

Given /click the "(.*)" link/i do |type|
  if link = getLink(@salad.browser, type) then
    ajax_before_action @salad.browser
    link.click
    ajax_after_action @salad.browser
  else
    fail("could not find the '#{type}' link on #{@salad.browser.url}")
  end
end

def getLink(browser, match)
	link = @salad.getElement('link', match, [:text,:class,:url,:xpath])
	if not (link and link.exists? and link.visible?)
		match = @baseURL + match
		link = @salad.getElement('link', match, [:text,:class,:url,:xpath])
	end
	return link
