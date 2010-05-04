Given /put "(.*)" in(?:to)? the "(.*)" field/i do |text,type|
#  field = @salad.getElement('text_field', type)
  field = @salad.getTextField(type)
  if field then
     field.set(text) 
  else
    fail("could not find the '#{type}' field to write '#{text}' into on #{@salad.browser.url}")
  end
end  


Given /The "(.*)" field is "(.*)"/i do |name, value|
  field = @salad.getTextField(name)

  if field then
     field.value.should == value
  else
    fail("could not find the '#{name}' field on #{@salad.browser.url}")
  end
end


# Synonyms
#Given /set "(.*)" to "(.*)"/i do |type,text|
#  Given "I put \"#{text}\" in the \"#{type}\" field"
#end

Given /The "(.*)" field is blank/i do |field|
    Given "The \"#{field}\" field is \"\""
end

Given /The value of "(.*)" becomes "(.*)"/i do |field, value|
  Given "The \"#{field}\" field is \"#{value}\""
end

