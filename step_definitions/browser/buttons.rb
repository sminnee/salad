# Try running with the button ":id", ":name", ":value", ":text", ":index" or ":class" element attribute.
# Does not matter what you select!
# The proper watir code will be executed regardless.

Given /click the "(.*)" button/i do |type|
  btn = getButton(@salad.browser, type)
  
  if(btn) then
    ajax_before_action @salad.browser
    btn.click
    ajax_after_action @salad.browser
  else
    fail("could not find the '#{type}' button on #{@salad.browser.url}")
  end
end

def getButton(browser, type)
  button = browser.button(:id, type)
  button = browser.button(:value, type) unless button.exists?

  # :text used for Firefox suport
  if browser.instance_of?(FireWatir::Firefox)
    button = browser.button(:text, type) unless button.exists?
  end
  # :xpath used for Safari suport
  button = browser.button(:xpath, "//button[.='#{type}']") unless button.exists?

  button = browser.button(:index, type) unless button.exists?
  button = browser.button(:class, type) unless button.exists?
  button = browser.button(:name, type) unless button.exists?
  
  button = nil unless button.exists?
  return button
end