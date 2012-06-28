Feature: Send confirmation emails
  In order give a customer a response
  As an admin
  I want to send an email to users

  @javascript
  Scenario: Go to the list of applicants and send some mails
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    And the following "registration_users" exist:
      | id | firstname | lastname | email        |
      | 1 | Tim       | Test     | "tim@test.de"  |
      | 2 | Tom       | Test     | "tom@test.de"  |
      | 3 | Tina      | Test     | "tina@test.de" |      
    When I go to the admin list of applicants
    Then I check "batch_action_item_1"
    And I check "batch_action_item_2"
    And I click on "Batch Actions"
    Then I click on "Send Default Conf Mails"
    #And "tim@test.de" should receive an email
    #And "tom@test.de" should receive an email
    
