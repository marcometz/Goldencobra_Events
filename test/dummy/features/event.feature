Feature: Create and manage events
  In order to make an programm
  As an author
  I want to create and manage some events

  Scenario: Go to the events admin site
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    When I go to the admin list of events
    Then I should see "Events"
    When I click on "New Event" within ".action_items"
    Then I should see "New Event" within "h2#page_title"
    And I fill in "event_title" with "Ausflug"
    And I fill in "event_description" with "Dies ist ein Ausflug nach Brandenburg"
    And I press "Create Event"
    Then I should see "Ausflug" within "#main_content"
    And I should see "Dies ist ein Ausflug nach Brandenburg" within "#main_content"
    
  Scenario: Create a subevent item
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    And the following "events" exist:
      | title    | id | parent_id |
      | "Event1" | 1 |  |
      | "Events" | 2 | 1 |
      | "Event3" | 3 | 1 |
    And I am on the admin list of events
    Then I should see "Events" within "h2"
    When I click on "New Subevent" within "tr#event_1"
    Then I should see "Event1" within "#event_parent_id"
    When I fill in "event_title" with "Sub of Event1"
    And I press "Create Event"
    Then I should see "Sub of Event1" within "table"
    When I click on "Edit Event"
    Then I should see "Event1" within "#event_parent_id"  
    
  Scenario: add an events to an article 
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    And the following "articles" exist:
      | title                        | startpage | id |
      | "Programm"                   | false     |  2 |
      | "Startseite"                 | false     |  1 |
    When I go to the admin list of articles  
    Then I click on "Edit" within "tr#article_2"
    And I should see "Article #2" within "#page_title"
    And I should see "Event Module" within "#sidebar"
    And I should see "Select Eventtree to display" within "#event_module_sidebar_section"

    
  