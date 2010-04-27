# Try running with the image ":src", ":id", ":name", ":index", ":class" element attribute.
# Does not matter what you select!
# The proper watir code will be executed regardless.

Given /click the "(.*)" image/i do |type|
  if @salad.browser.image(:src, type).exists? then
     @salad.browser.image(:src, type).click
  elsif 
    @salad.browser.image(:id, type).exists? then
    @salad.browser.image(:id, type).click
  elsif 
    @salad.browser.image(:name, type).exists? then
    @salad.browser.image(:name, type).click
  elsif 
    @salad.browser.image(:text, type).exists? then
    @salad.browser.image(:text, type).click
  elsif 
    @salad.browser.image(:index, type).exists? then
    @salad.browser.image(:index, type).click
  elsif 
    @salad.browser.image(:class, type).exists? then
    @salad.browser.image(:class, type).click
  else
    fail("could not find what you asked for")  
  end
end