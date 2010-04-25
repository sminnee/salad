Feature: Salad self-tests for form fields

	Scenario: Identify, and select radio buttons
		Given I visit tests/form-fields.html
		And I click the "ID_RadioA" radio button
		Then "Option 1" is selected
		And I click the "two" radio button
		Then "ID_RadioB" is selected
		And I click the "Different option" radio button
		Then "radiogroup2" is selected
