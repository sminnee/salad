Feature: Salad self-tests for popup windows.

	Background:
		Given I visit tests/form-fields.html
	
	Scenario: Test basic links
		When I click the "SilverStripe.org" link
		Then I am at http://silverstripe.org
		And I see "A CMS for website editors"

	Scenario: Test links with the target "_blank"
		When I click the "New Window" link
		And I look in the window "New Window Test"
		Then I am at tests/new-window.html
		And I see "This is a new window."

	Scenario: Test links which use window.open
		When I click the "Google" link
		And I look in the window "Google"
		Then I am at http://www.google.co.nz

