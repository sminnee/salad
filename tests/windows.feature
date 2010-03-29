Feature: Salad self-tests for popup windows.

	Scenario: Test basic links
		Given I visit tests/form-fields.html
		And I click the "SilverStripe.org" link
		Then the website URL is http://silverstripe.org

	Scenario: Test links with the target "_blank"
		Given I visit tests/form-fields.html
		And I click the "SilverStripe" link
		And I look in the window titled "SilverStripe.com - Open Source CMS / Framework"
		Then I see "Welcome to SilverStripe."

	Scenario: Test links which use window.open
		Given I visit tests/form-fields.html
		And I click the "Google" link
		And I look in the window titled "Google"
		Then the website URL is http://www.google.co.nz

