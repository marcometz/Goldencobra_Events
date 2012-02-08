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
    And I select "February" within "#event_start_date_2i"
    And I press "Create Event"
    Then I should see "Ausflug" within "#main_content"
    And I should see "Dies ist ein Ausflug nach Brandenburg" within "#main_content"
    And I should see "February"
    
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
    And the following "events" exist:
        | title                        | parent_id | id |
        | "Event1"                     |           |  1 |
        | "Event2"                     | 1         |  2 |  
    When I go to the admin list of articles  
    Then I click on "Edit" within "tr#article_2"
    And I should see "Edit Article" within "#page_title"
    And I should see "Event Module" within "#sidebar"
    And I should see "Select an event tree to display" within "#event_module_sidebar_section"
    And I select "Event2" within "#article_event_id"
    When I press "Event zuweisen"
    Then I should see "Edit Article" within ".action_items"
    And I click on "Edit Article"
    And I should see "Event2" within "#article_event_id"
    
  Scenario: visit an article and look for events 
    Given the following "articles" exist:
      | title                        | startpage | id | url_name    | event_id | event_levels | active  |
      | "Programm"                   | false     |  1 | programm    |    1     |   2         | true    |
      | "Unterprogramm"              | false     |  2 | subprogramm |    2     |   0          | true    |
    And the following "events" exist:
        | title                        | parent_id | id | active |
        | "Event1"                     |           |  1 | true   |
        | "Event2"                     | 1         |  2 | true   |
        | "Event3"                     | 1         |  3 | true   | 
        | "Event4"                     | 2         |  4 | true   |
        | "InvisibleEvent"             | 2         |  5 | false  |
    And the following "pricegroup" exist:
        | title                        | id |
        | "Studenten"                  |  1 |
    When I visit url "/programm"
    Then I should see "Programm"
    And I should see "Event1"
    And I should see "Event2"
    And I should see "Event3"
    And I should not see "Event4"
    When I visit url "/subprogramm"
    Then I should see "Event4"
    And I should see "Event2"
    And I should not see "Event1"
    And I should not see "Event3"
    And I should not see "InvisibleEvent"
    
    
  @javascript  
  Scenario: add prices to existing event
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    And the following "pricegroup" exist:
        | title                        | id |
        | "Studenten"                  |  1 |
    And the following "events" exist:
        | title                        | parent_id | id |
        | "Event"                      |           |  1 |
    When I go to the admin list of events  
    Then I click on "Edit" within "tr#event_1"
    And I should see "Edit Event" within "#page_title"
    When I click on "Add New Event Pricegroup"
    Then I should see "Studenten"
    And I should see "Price"
    And I fill in "Price" with "10.5"
    Then I press "Update Event"
    And I should see "Studenten"
    And I should see "10"
    
    
  Scenario: add teaser image to existign event
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    And the following "events" exist:
      | title                        | parent_id | id |
      | "Event"                      |           |  1 |  
    And the following uploads exist:
      | image_file_name | source  | rights |
      | "Bild1"         | "ikusei" | "alle" |
   When I go to the admin list of events  
   Then I click on "Edit" within "tr#event_1"
   And I select "Bild1" within ".teaser_image"
   Then I press "Update Event"
   And I click on "Edit Event"
   And I should see "Bild1"
  
  @javascript  
  Scenario: add webcode to existing event
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    And the following "pricegroup" exist:
        | title                        | id |
        | "Studenten"                  |  1 |
    And the following "events" exist:
        | title                        | parent_id | id |
        | "Event"                      |           |  1 |
    When I go to the admin list of events  
    Then I click on "Edit" within "tr#event_1"
    When I click on "Add New Event Pricegroup"
    And I fill in "Webcode" with "Osterspezial2010"
    Then I press "Update Event"
    And I should see "Osterspezial2010"

  Scenario: add event to an existing panel
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    And the following "events" exist:
      | title                        | parent_id | id |
      | "Event"                      |           |  1 |
    And the following "panels" exist:
      | title                        | id |
      | "Naturstrom Panel"           |  1 |
    When I go to the admin list of events  
    Then I click on "Edit" within "tr#event_1"
    And I select "Naturstrom Panel" within "#event_panel_id"
    Then I press "Update Event"
    And I should see "Naturstrom Panel"

  Scenario: Set event type and registration type for existing event
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    And the following "events" exist:
      | title                        | parent_id | id |
      | "Event"                      |           |  1 |
    When I go to the admin list of events
    Then I click on "Edit" within "tr#event_1"
    And I select "Registration needed" within "#event_type_of_event"
    And I select "No cancellation required" within "#event_type_of_registration"
    Then I press "Update Event"
    And I should see "Registration needed"
    And I should see "No cancellation required"

  Scenario: Set sponsors for an event
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    And the following "events" exist:
      | title                       | parent_id | id |
      | "Event"                     |           |  1 |
    And the following "sponsors" exist:
      | title              | description | id |
      | "Audi Deutschland" | "Autos"     |  1 |
      | "Dr. Oetker"       | "Speisen"   |  2 |
    When I go to the admin list of events
    Then I click on "Edit" within "tr#event_1"
    And I check "Audi Deutschland"
    Then I press "Update Event"
    And I should see "Audi Deutschland"
