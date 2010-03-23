Feature: Salad self-tests for ajax

	Scenario: Perform ajax testing
		Given I visit tests/form-fields.html
		And I click the "ID_AjaxButton2" button
		Then the element "ID_AjaxResult" contains "This was retrieved via AJAX."

		#Then the div "ID_AjaxResult" contains "This was retrieved via AJAX."
		#Given I click the "ID_ClearButton" button
		#Then the div "ID_AjaxResult" contains "This was retrieved via AJAX."

		# Then I don't see "This was retrieved via AJAX."
		# Given I click the "ID_AjaxButton2" button
		# Then I see "This was retrieved via AJAX."
		# Given I click the "ID_AjaxButton3" button
		# Then I don't see "This was retrieved via AJAX."
