Feature: Salad self-tests for form fields

	Background:
		Given I visit tests/form-fields.html
	
	Scenario: Identify, and select checkboxes
		When I click the "ID_CheckboxA" checkbox
		Then the checkbox "Item one" is checked

		When I click the "Item one" checkbox
		Then the checkbox "Item 1" is not checked
		And the checkbox "Item 2" is not checked
		And the checkbox "CheckboxC" is not checked
