Feature: Create and manage panels
  In order to make a panel
  As an admin
  I want to create and manage some panels

  Scenario: Go to the panel admin site
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    When I go to the admin list of event_panels
    Then I should see "Panels"
    When I click on "New Panel" within ".action_items"
    Then I should see "New Panel" within "h2#page_title"
    And I fill in "event_panel_title" with "Naturstrom Panel"
    And I press "Create Panel"
    And I should see "Naturstrom Panel" within "#main_content"

  Scenario: Set sponsors for a panel
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    And the following "panels" exist:
      | title                       | id |
      | "Naturstrom Panel"          |  1 |
    And the following "sponsors" exist:
      | title              | description | id |
      | "Audi Deutschland" | "Autos"     |  1 |
      | "Dr. Oetker"       | "Speisen"   |  2 |
    When I go to the admin list of event_panels
    Then I click on "Edit" within "tr#panel_1"
    And I check "Audi Deutschland"
    And I check "Dr. Oetker"
    Then I press "Update Panel"
    And I should see "Audi Deutschland"
    And I should see "Dr. Oetker"
