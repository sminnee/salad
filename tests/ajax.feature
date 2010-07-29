Feature: Salad self-tests for ajax

	Background:
		Given I visit tests/form-fields.html
	
	Scenario: Perform ajax testing
		When I click "ajax3"
		And I click the "ID_AjaxButton1" button
		Then I see "This was retrieved via AJAX."

		When I click the "ajax3" button
		Then I don't see "This was retrieved via AJAX."

		When I click the "Short delay" button
		Then I see "This was retrieved via AJAX."

		When I click the "Clear field" button
		Then I don't see "This was retrieved via AJAX."