# Try running with the select-list ":id", ":name", ":value", ":text", ":index" or ":class" element attribute.
# Does not matter what you select!
# The proper watir code will be executed regardless.

Given /select "(.*)" from "(.*)"/i do |text, type|
  selectList = getSelect(@salad.browser, type)
  if selectList
    selectList.select(text)
  else
    fail("could not find what you asked for")
  end
end


Given /"(.*)" is selected in "(.*)"/i do |text, field|
  field_elt = getSelect(@salad.browser, field)

  if field_elt then
		fail("'#{text}' wasn't selected in the field '#{field}'") unless @salad.selected_options(field_elt).index(text)
  else
    fail("could not find the '#{field}' field on #{@salad.browser.url}")
  end
end


def getSelect(browser, match)
  item = browser.select_list(:id, match)
  item = browser.select_list(:name, match) unless item and item.exists? and item.visible?
#  item = browser.select_list(:xpath, match) unless item and item.exists? and item.visible?

	# Try to find control by its label
	if not (item.exists? and item.visible?) then
		label = browser.label(:text, match)
		if label.exists? then
			itemid = @salad.getAttribute(label, 'for')
			item = browser.select_list(:id, itemid)
		end
	end

  if not item.exists? and item.visible? then item = nil end

  return item
end

