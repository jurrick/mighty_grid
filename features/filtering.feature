Feature: Filtering

  Background:
    Given I generate 100 users

  Scenario: Filtering by text_field
    Given I am on the list of users page
    When I fill in "Name" with "user001"
    And I press "Apply changes"
    Then I should see "user001"
    And the "Name" field should contain "user001"
    And I should see "1 of 1"

  Scenario: Filtering by select
    Given I am on the list of users page
    When I select "Admin" from "Role"
    And I press "Apply changes"
    Then I should see "admin001"
    And "Admin" should be selected for "Role"
    And I should see "1 of 1"

  Scenario: Filtering by checkox
    Given I am on the list of users page
    When I check "Banned"
    And I press "Apply changes"
    Then the "Banned" checkbox should be checked
    And I should see "user101"
    And I should see "1 of 1"

  # Scenario: Reset filter
  #   Given I am on the list of users page
  #   When I fill in "Name" with "user001"
  #   And I select "Admin" from "Role"
  #   And I check "Banned"
  #   And I press "Apply changes"
  #   Then the "Name" field should contain "user001"
  #   And "Admin" should be selected for "Role"
  #   And the "Banned" checkbox should be checked
  #   When I press "Reset changes"
  #   Then the "Name" field should contain ""
  #   And nothing should be selected for "Role"
  #   And the "Banned" checkbox should not be checked