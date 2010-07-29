Feature: Salad self-tests for ajax

	Background:
		Given I visit tests/form-fields.html
	
	Scenario: Perform testing of generalised vocabulary
		When I click "ID_AjaxButton1"
		And I click "ID_RadioA"
                Then I inspect "IFrame1"
		And I click "ID_RadioB"
                Then I inspect the whole page
		And I click "Item one"
		And I set "Select A" to "two"
		And I set "FieldB" to "Abcde"
		Then "Item one" is checked
                Then I inspect "IFrame1"
		Then "I Option 2" is selected
                Then I inspect the whole page
		And I see "This was retrieved via AJAX."
		And "ID_RadioA" is selected
		And "Field B" is "Abcde"
		And "SelectA" is set to "two"


