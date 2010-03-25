Given /visit (.*)/o do |url|
  @browser.goto(@baseURL + url)
end

Given /I am at (.*)/i do |url|
  @salad.url(@browser).should =~ /^#{@baseURL}#{url}/
end

  Given /I am sent to (.*)/i do |url|
    Given "I am at #{url}"
  end
  
Given /url (.*) does not exist/ do |url|
  Given "I visit #{url}"
  # Brittle - needs to check that actual 404 status, but that's hard
  And "I see \"The requested page couldn't be found.\""
end