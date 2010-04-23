Given /put "(.*)" in(?:to)? the "(.*)" field/i do |text,type|
  field = @salad.getElement(type) { |how,what| @salad.browser.text_field(how,what) }
  field = getTextField(@salad.browser, type)
  if field then
     field.set(text) 
  else
    fail("could not find the '#{type}' field to write '#{text}' into on #{@salad.browser.url}")
  end
end  


Given /The "(.*)" field is "(.*)"/i do |name, value|
  field = getTextField(@salad.browser, name)

  if field then
     field.value.should == value
  else
    fail("could not find the '#{name}' field on #{@salad.browser.url}")
  end
end

# Synonyms
Given /set "(.*)" to "(.*)"/i do |type,text|
  Given "I put \"#{text}\" in the \"#{type}\" field"
end

Given /The "(.*)" field is blank/i do |field|
    Given "The \"#{field}\" field is \"\""
end

Given /The value of "(.*)" becomes "(.*)"/i do |field, value|
  Given "The \"#{field}\" field is \"#{value}\""
end

# Try running with the text_field ":id", ":name", ":value", ":index" or ":class" element attribute.
# Does not matter what you select!
# The proper watir code will be executed regardless.

def getTextField(browser, type)
  # Build an array of all potential fields
  fields = []
  # By ID
  browser.text_fields().each { | field |
    if field.id == type then fields.push field end
  }
  # By Name
  browser.text_fields().each { | field |
    if field.respond_to?('htmlname') then
      if field.htmlname == type then fields.push field end
    else
      if field.name == type then fields.push field end
    end
  }
  # By the associated <label>
  matchingLabels = browser.elements_by_xpath("//label[.='#{type}']")
  if matchingLabels then
    matchingLabels.each { | label |
      labelFor = @salad.getAttribute(label, 'for')

      if labelFor then
        browser.text_fields().each { | field |
          if @salad.getAttribute(field,'id') == labelFor then fields.push field end
        }
      end
    }
  end
  
  # Return the first visible one
  fields.each { | field |
    if field.visible? then return field end
  }
  return nil
end

