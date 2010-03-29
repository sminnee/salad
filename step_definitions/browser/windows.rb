Given /look in the window titled "(.*)"/i do |text|
  win = @browser.attach(:title, text)
	if not win
    fail("could not find the '#{text}' link on #{@browser.url}")
  end
end

Given /look in the window showing (.*)/i do |text|
  win = @browser.attach(:url, text)
	if not win
    fail("could not find the '#{text}' link on #{@browser.url}")
  end
end
