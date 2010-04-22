Feature: Salad self-tests for form fields

	Scenario: Identify, and select radio buttons
		Given I visit tests/form-fields.html
		And I click the "ID_RadioA" radio button
		Then the "Option 1" radio button is selected
		And I click the "two" radio button
		Then the radio button "ID_RadioB" is selected
		And I click the "Different option" radio button
		Then the radio button "radiogroup2" is selected
