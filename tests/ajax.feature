Feature: Salad self-tests for ajax

	Scenario: Perform ajax testing
		Given I visit tests/form-fields.html
		And I click "ajax3"
		And I click the "ID_AjaxButton1" button
		Then I see "This was retrieved via AJAX."

		Given I click the "ajax3" button
		Then I don't see "This was retrieved via AJAX."

		Given I click the "Short delay" button
		Then I see "This was retrieved via AJAX."

		Given I click the "Clear field" button
		Then I don't see "This was retrieved via AJAX."