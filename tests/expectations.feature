Feature: Salad self-tests for basic expectations

	Background:
		Given I visit tests/form-fields.html
	
	Scenario: Look for text we know to be there
		Then I see "These buttons will cause confirm() popups"
		And I see "These are links, some of which open new windows:"
		And I see "Check some of the following:"
		And I don't see "Green eggs and ham"
