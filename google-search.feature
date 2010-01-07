Feature: Google Search
	As a user of the web
	I want to search for interesting websites
	So that I can find things on the web.
	
	Scenario: Search for SilverStripe
		Given I visit /
		When I put "SilverStripe" in the "q" field
		And I click the "Google Search" button
		Then I see "www.silverstripe.com"
		And I see "Open Source CMS / Framework"
