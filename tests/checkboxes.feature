Feature: Salad self-tests for form fields

	Scenario: Identify, and select checkboxes
		Given I visit tests/form-fields.html
		And I click the "ID_CheckboxA" checkbox
		Then the checkbox "Item one" is checked
		And I click the "Item one" checkbox
		Then the checkbox "Item 1" is not checked
		And the checkbox "Item 2" is not checked
		And the checkbox "CheckboxC" is not checked
