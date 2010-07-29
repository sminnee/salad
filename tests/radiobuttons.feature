Feature: Salad self-tests for form fields

	Background:
		Given I visit tests/form-fields.html
	
	Scenario: Identify, and select radio buttons
		When I click the "ID_RadioA" radio button
		Then "Option 1" is selected

		When I click the "two" radio button
		Then "ID_RadioB" is selected

		When I click the "Different option" radio button
		Then "radiogroup2" is selected
