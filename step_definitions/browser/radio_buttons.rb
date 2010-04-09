# Try running with the radio ":id", ":name", ":value", ":text", ":index" or ":class" element attribute.
# Does not matter what you select!
# The proper watir code will be executed regardless.

Given /click the "(.*)" radio button/i do |type|
  if @salad.browser.radio(:id, type).exists? then
     @salad.browser.radio(:id, type).click
  elsif 
    @salad.browser.radio(:name, type).exists? then
    @salad.browser.radio(:name, type).click
  elsif 
    @salad.browser.radio(:value, type).exists? then
    @salad.browser.radio(:value, type).click
  elsif 
    @salad.browser.radio(:text, type).exists? then
    @salad.browser.radio(:text, type).click
  elsif 
    @salad.browser.radio(:index, type).exists? then
    @salad.browser.radio(:index, type).click
  elsif 
    @salad.browser.radio(:class, type).exists? then
    @salad.browser.radio(:class, type).click
  else
    fail("could not find what you asked for")
  end
end