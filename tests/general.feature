Feature: Salad self-tests for ajax

	Scenario: Perform testing of generalised vocabulary
		Given I visit tests/form-fields.html
		And I click "ID_AjaxButton1"
		And I click "ID_RadioA"
		And I click "Item one"
		And I set "Select A" to "two"
		And I set "FieldB" to "Abcde"
		Then "Item one" is checked
		And I see "This was retrieved via AJAX."
		And "ID_RadioA" is selected
		And "Field B" is "Abcde"
		And "SelectA" is set to "two"


