# Try running with the link ":id", ":text", ":class" element attribute.
# Does not matter what you select!
# The proper watir code will be executed regardless.

Given /click the "(.*)" link[., \t]*$/i do |type|
  if link = @salad.getLink(type) then
    ajax_before_action @salad.browser
    link.click
    ajax_after_action @salad.browser
  else
    fail("could not find the '#{type}' link on #{@salad.browser.url}")
  end
end
