Given /visit (.*)[., \t]*$/o do |url|
  @salad.browser.goto(@baseURL + url)
end

Given /I am at (.*)[., \t]*$/i do |url|
  if url =~ /^https?:\/\// then
    @salad.url().should =~ /^#{url}/
  else
    @salad.url().should =~ /^#{@baseURL}#{url}/
  end
end

Given /I am sent to (.*)[., \t]*$/i do |url|
	step "I am at #{url}"
end
  
Given /url (.*) (?:does not|doesn't) exist[., \t]*$/ do |url|
  step "I visit #{url}"
  # Brittle - needs to check that actual 404 status, but that's hard
  step "I see \"The requested page could not be found.\""
end
