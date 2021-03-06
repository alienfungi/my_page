Feature: User Management
  In order to manage users
  As an authorized individual
  I want to be able to create, edit, delete users

  Background:
    Given the following user records
      | username | email           | password | admin | confirmed |
      | Dick     | email@email.com | password | false | true      |
      | Jane     | admin@email.com | password | true  | true      |

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
    And I press "Create User"
    Then I should be on login page
    And I should see "Please confirm your account via the email sent to you."

  Scenario: Visiting the user index page
    Given I am logged in as wombat_krusha
    When I click "Users"
    Then I should be on users page
    And I should see "Dick"
    And I should see "Jane"

  Scenario: Visiting a user page
    Given I am logged in
    And I am on the users page
    When I click "Dick"
    Then I should be on an individual users page
    And I should see "Dick"

  Scenario: A user should be able to edit his info
    Given I am logged in
    When I click "My Profile"
    And I press "Options"
    And I click "Edit"
    And I fill in "Username" with "aNew_username"
    And I fill in "Password" with "newPassword"
    And I fill in "Confirm Password" with "newPassword"
    And I fill in "About" with "New stuff about me!"
    And I fill in "Headline" with "Awesome stuff."
    And I press "Update"
    Then I should be on an individual users page
    And I should see "aNew_username"
    And I should see "New stuff about me!"
    And I should see "Awesome stuff."

  Scenario: An admin should be able to delete users
    Given I am logged in as admin
    And I am on the users page
    When I click "Jane"
    And I press "Options"
    And I click "Delete"
    And I click "Delete User"
    Then the User should be deleted
    And I should be on users page
