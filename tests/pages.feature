Feature: Salad self-tests for pages

	Scenario: Visit URLs and make sure we got there
		When I visit tests/form-fields.html
		Then I am sent to tests/form-fields.html
