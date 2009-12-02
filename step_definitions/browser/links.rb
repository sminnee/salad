# Try running with the link ":id", ":text", ":class" element attribute.
# Does not matter what you select!
# The proper watir code will be executed regardless.

Given /click the "(.*)" link/i do |type|
  if link = getLink(@browser, type) then
    ajax_before_action @browser
    link.click
    ajax_after_action @browser
  else
    fail("could not find the '#{type}' link on #{@browser.url}")
  end
end

def getLink(browser, match)
  link = browser.link(:id, match)
  if not link.exists? then link = browser.link(:text, match) end
  if not link.exists? then link = browser.link(:class, match) end
  # Try the URL with both the baseURL prefix and without it
  if not link.exists? then link = browser.link(:url, @baseURL + match) end
  if not link.exists? then link = browser.link(:url, match) end
  if not link.exists? then link = browser.link(:xpath, match) end
  if not link.exists? then link = nil end

  return link
end
