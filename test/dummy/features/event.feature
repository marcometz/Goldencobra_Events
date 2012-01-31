Feature: Create and manage events
  In order to make an programm
  As an author
  I want to create and manage some events

  Scenario: Go to the events admin site
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    When I go to the admin list of events
    Then I should see "Events"
    When I click on "New Event"