Feature: User Management
  In order to manage users
  As an authorized individual
  I want to be able to create, edit, delete users

  Background:
    Given the following user records
      | username | email           | password | admin |
      | Dick     | email@email.com | password | false |
      | Jane     | admin@email.com | password | true  |

  Scenario: Visiting the new user page
    Given I am on the login page
    When I click "New User"
    Then I should be on new user page

  Scenario: Creating a new user
    Given I am on the new user page
    When I fill in "Email" with "some@email.com"
    And I fill in "Username" with "name"
    And I fill in "Password" with "password"
    And I fill in "Confirm Password" with "password"
    And I press "Submit"
    Then I should be on home page
    And the User should be created

  Scenario: Visiting the user index page
    Given I am logged in as wombat_krusha
    When I click "wombat_krusha"
    And I click "Users"
    Then I should be on users page
    And I should see "Dick"
    And I should see "Jane"

  Scenario: Visiting a user page
    Given I am logged in
    And I am on the users page
    When I click "Dick"
    Then I should be on an individual users page
    And I should see "Dick"
