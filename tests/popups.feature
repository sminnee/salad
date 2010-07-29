Feature: Check that popup confirmation is handled correctly
	I want to be able to check that the system responds correctly to popup confirmation windows

	Background:
		Given I visit tests/form-fields.html
	
	Scenario: The user cancels popup windows for one button
		Given I cancel popups
		When I click the "Confirm one" button
		Then I see "No was clicked for PopupButton1"

	Scenario: The user accepts popup windows for the other button
		Given I confirm popups
		When I click the "ID_PopupButton2" button
		Then I see "Yes was clicked for PopupButton2"

	Scenario: The user enters text for prompts
		When I put "Test" in the popup
		And I click the "Enter text" button
		Then I see "You entered: Test"

		Given I cancel popups
		When I click the "ID_PopupButton3" button
		Then I see "PopupButton3 was cancelled"

