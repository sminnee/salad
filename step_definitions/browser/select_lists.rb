# Try running with the select-list ":id", ":name", ":value", ":text", ":index" or ":class" element attribute.
# Does not matter what you select!
# The proper watir code will be executed regardless.

Given /select "(.*)" from "(.*)"/i do |text, type|
  selectList = @salad.getSelect(type)
  if selectList
    selectList.select(text)
  else
    fail("could not find what you asked for")
  end
end
