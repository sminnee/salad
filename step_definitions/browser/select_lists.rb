# Try running with the select-list ":id", ":name", ":value", ":text", ":index" or ":class" element attribute.
# Does not matter what you select!
# The proper watir code will be executed regardless.

Given /select "(.*)" from "(.*)"/i do |text, type|
  selectList = getSelect(@browser, type)
  if selectList
    selectList.select(text)
  else
    fail("could not find what you asked for")
  end
end

Given /"(.*)" is selected in "(.*)"/i do |text, field|
  pending
end
  
  
def getSelect(browser, match)
  item = browser.select_list(:name, match)
  if not item.exists? then item = browser.select_list(:id, match) end
  if not item.exists? then item = browser.select_list(:xpath, match) end
  if not item.exists? then item = nil end
    
  # To do: make more like textfield selection (by label, for example)

  return item
end
