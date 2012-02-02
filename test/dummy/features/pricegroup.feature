Feature: Create and manage pricegroups
  In order to make a pricegroup
  As an admin
  I want to create and manage some pricegroups

  Scenario: Go to the pricegroup admin site
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    When I go to the admin list of pricegroups
    Then I should see "Pricegroups"
    When I click on "New Pricegroup" within ".action_items"
    Then I should see "New Pricegroup" within "h2#page_title"
    And I fill in "pricegroup_title" with "Studenten"
    And I press "Create Pricegroup"
    And I should see "Studenten" within "#main_content"
    