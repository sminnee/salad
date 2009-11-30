# Try running with the button ":id", ":name", ":value", ":text", ":index" or ":class" element attribute.
# Does not matter what you select!
# The proper watir code will be executed regardless.

Given /click the "(.*)" button/i do |type|
  btn = getButton(@browser, type)
  
  if(btn) then
    ajax_before_action @browser
    btn.click
    ajax_after_action @browser
  else
    fail("could not find the '#{type}'button on #{@browser.url}")
  end
end

def getButton(browser, type)
  if browser.button(:id, type).exists? then
    return browser.button(:id, type)
  elsif
    browser.button(:name, type).exists? then
    return button(:name, type)
  elsif
    browser.button(:value, type).exists? then
    return browser.button(:value, type)
  elsif
    # XPath used for Safari *and* FireWatir support
    browser.button(:xpath, "//button[.='#{type}']").exists? then
    return browser.button(:xpath, "//button[.='#{type}']")
  elsif
    browser.button(:index, type).exists? then
    return browser.button(:index, type)
  elsif
    browser.button(:class, type).exists? then
    return browser.button(:class, type)
  else
    return nil
  end
end