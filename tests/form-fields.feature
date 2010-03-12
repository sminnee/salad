Feature: Salad self-tests for form fields
	
	Scenario: Identify, populate, and read text fields
		Given I visit tests/form-fields.html
		And I put "A" in the "Field A" field
		And I put "B" in the "ID_FieldB" field
		And I put "C" in the "FieldC" field
		Then the "FieldA" field is "A"
		And the "Field B" field is "B"
		And the "ID_FieldC" field is "C"
		
	Scenario: Identify, populate, and read dropdowns
		Given I visit tests/form-fields.html
#		And I select "two" from "Select A"
		And I select "three" from "ID_SelectB"
		And I select "four" from "SelectC"
#		Then the "SelectA" field is "two"
#		And the "Select B" field is "three"
#		And the "ID_SelectC" field is "four"
	