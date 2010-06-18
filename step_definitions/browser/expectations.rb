Given /I see "(.*)"/ do |text|
	fail("'#{text}' not found") unless @salad.hasText?(text)
end

Given /I don't see "(.*)"/ do |text|
	fail("'#{text}' was found when it shouldn't be.") if @salad.hasText?(text)
end

Given /I wait for "(.*)"/ do |text|
	Watir::Waiter::wait_until { @salad.hasText?(text) }
end

Given /I wait for html "(.*)"/ do |text|
	Watir::Waiter::wait_until { @salad.hasHTML? text}
end

# Wait for time
Given /Wait ([0-9]+)s$/i do |seconds|
  sleep seconds.to_i
end

