Feature: Salad self-tests for form fields
	
	Scenario: Identify, populate, and read text fields
		Given I visit tests/form-fields.html
		And I put "A" in the "Field A" field
		And I put "B" in the "ID_FieldB" field
		And I put "C" in the "FieldC" field
		And I put "D" in the "FieldD" field
		Then the "FieldA" field is "A"
		And the "Field B" field is "B"
		And the "ID_FieldC" field is "C"
		And the "ID_FieldD" field is "D"
		
	Scenario: Identify, populate, and read dropdowns
		Given I visit tests/form-fields.html
		And I select "two" from "Select A"
		And I select "three" from "ID_SelectB"
		And I select "four" from "SelectC"
		Then "SelectA" is "two"
		And "Select B" is set to "three"
		And "ID_SelectC" is set to "four"
