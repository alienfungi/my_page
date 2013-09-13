Feature: Messaging
  In order to communicate with other users
  As a logged in user
  I want to be able to send and receive messages

  Background:
    Given the following user records
      | username | email           | password | admin |
      | Dick     | email@email.com | password | false |
      | Jane     | admin@email.com | password | true  |

  Scenario: Preparing to send a message to another user
    Given I am logged in
    And I click "Users"
    And I click "Jane"
    When I press "Options"
    And I click "Send Message"
    Then I should be on new message page

  Scenario: Sending a message
    Given I am logged in
    And I am on the new message page
    When I fill in "Recipient" with "email@email.com"
    And I fill in "Subject" with "some subject"
    And I fill in "Message" with "some random message!"
    And I press "Send Message"
    Then I should be on new message page
    And I should see "Message sent."

