Given /I see "(.*)"/ do |text|
  describe "Matcher" do
    it "should have text" do
      @browser.should have_text(text)
    end
  end
end

Given /I don't see "(.*)"/ do |text|
  describe "Matcher" do
    it "shouldn't have text" do
      @browser.should_not have_text(text)
    end
  end
end

Given /I wait for "(.*)"/ do |text|
  Watir::Waiter::wait_until { @browser.text.include? text}
end

Given /I wait for html "(.*)"/ do |text|
  Watir::Waiter::wait_until { @browser.html.include? text}
end

# Wait for time
Given /Wait ([0-9]+)s$/i do |seconds|
  sleep seconds.to_i
end

