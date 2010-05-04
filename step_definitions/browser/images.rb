# Try running with the image ":src", ":id", ":name", ":index", ":class" element attribute.
# Does not matter what you select!
# The proper watir code will be executed regardless.

Given /click the "(.*)" image/i do |type|
  image = @salad.getImage(type)
  if (image) then
     image.click
  else
    fail("could not find what you asked for")  
  end
end