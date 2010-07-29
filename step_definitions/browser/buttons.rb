# Try running with the button ":id", ":name", ":value", ":text", ":index" or ":class" element attribute.
# Does not matter what you select!
# The proper watir code will be executed regardless.

Given /click the "(.*)" button[., \t]*$/i do |which|
  btn = @salad.getButton(which)
  
  if(btn) then
    ajax_before_action @salad.browser
    btn.click
    ajax_after_action @salad.browser
  else
    fail("could not find the '#{which}' button on #{@salad.browser.url}")
  end
end
