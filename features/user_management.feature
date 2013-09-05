Feature: User Management
  In order to manage users
  As an authorized individual
  I want to be able to create, edit, delete users

  Background:
    Given the following user records
      | email           | password | admin |
      | email@email.com | password | false |
      | admin@email.com | password | true  |

  Scenario: Visiting the new user page
    Given I am on the login page
    When I click "New User"
    Then I should be on new user page

  Scenario: Creating a new user
    Given I am on the new user page
    When I fill in "Email" with "some@email.com"
    And I fill in "Password" with "password"
    And I fill in "Confirm Password" with "password"
    And I press "Submit"
    Then I should be on home page
    And the User should be created
