Feature: Send confirmation emails
  In order give a customer a response
  As an admin
  I want to send an email to users

  @javascript
  Scenario: Go to the list of applicants and send some mails
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    And the following "registration_users" exist:
      
    When I go to the admin list of applicants
    And "marco.metz@gmail.com" should receive an email with subject "Eigene Internetseite - NW-Anfrage"
    When I open the email with subject "Eigene Internetseite - NW-Anfrage"
    Then I should see "Eigene Internetseite - NW-Anfrage" in the email body
    And I should see the email delivered from "mercedes-sonderverkauf@ikusei.de"
    
