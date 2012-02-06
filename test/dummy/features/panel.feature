Feature: Create and manage panels
  In order to make a panel
  As an admin
  I want to create and manage some panels

  Scenario: Go to the panel admin site
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    When I go to the admin list of event_panels
    Then I should see "Event Panels"
    When I click on "New Event Panel" within ".action_items"
    Then I should see "New Event Panel" within "h2#page_title"
    And I fill in "event_panel_title" with "Naturstrom Panel"
    And I press "Create Panel"
    And I should see "Naturstrom Panel" within "#main_content"
