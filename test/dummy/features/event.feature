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
    And I select "February" within "#event_end_date_2i"
    And I select "1" within "#event_end_date_3i"
    And I select "2012" within "#event_end_date_1i"
    And I press "Create Event"
    Then I should see "Ausflug" within "#main_content"
    And I should see "Dies ist ein Ausflug nach Brandenburg" within "#main_content"
    And I should see "February" within "#main_content"
    And I should see "2012" within "#main_content"
    
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
    Then I should see "Sub of Event1" 
    Then I should see "Event1" 
    
  Scenario: add an events to an article as a programm site 
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
    And I should see "Veranstaltungs Modul" within "#sidebar"
    And I should see "Wähle ein Veranstaltungsbaum aus" within "#veranstaltungs_modul_sidebar_section"
    And I select "Event2" within "#article_event_id"
    When I press "Event zuweisen"
    And I should see "Event2"

  Scenario: add an events to an article as a registration site 
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    And the following "pricegroup" exist:
      | title                      | id |
      | Studenten                  |  1 |
      | Frühbucher                 |  2 |
    And the following "articles" exist:
      | title                        | startpage | id | url_name   |
      | "Anmeldung"                  | false     |  2 | anmeldung  |
      | "Startseite"                 | false     |  1 | startseite |
    And the following "events" exist:
        | title                        | parent_id | id | type_of_event |
        | "Event1"                     |           |  1 | Registration needed |
        | "Event2"                     | 1         |  2 | No Registration needed |
    And the following "event_pricegroups" exist:
        | id | event_id | pricegroup_id | price | max_number_of_participators | available | start_reservation     | cancelation_until     | end_reservation       | webcode |
        | 5  |        1 |             1 |  50.0 |                         500 |      true | "2012-02-10 12:00:00" | "2012-04-01 12:00:00" | "2012-03-01 12:00:00" |         |
        | 6  |        1 |             2 |  30.0 |                         200 |      true | "2012-02-01 12:00:00" | "2012-04-01 12:00:00" | "2012-02-09 12:00:00" |         |
    When I go to the admin list of articles  
    Then I click on "Edit" within "tr#article_2"
    And I should see "Edit Article" within "#page_title"
    And I select "Event1" within "#article_event_id"
    And I select "Anmeldung" within "#article_eventmoduletype"
    When I press "Event zuweisen"
    And I should see "Event1" within "#article_event_id"
    And I should see "Anmeldung" within "#article_eventmoduletype"
    Then I visit url "/anmeldung"
    And I should see "50,00"
    And I should see "Studenten"
    And I should not see "Event2"
    
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
    And I should not see "Event1"
    And I should see "Event2"
    And I should see "Event3"
    And I should not see "Event4"
    When I visit url "/subprogramm"
    Then I should see "Event4"
    And I should see "Event2"
    And I should not see "Event1"
    And I should not see "Event3"
    And I should not see "InvisibleEvent"
    
    
  Scenario: visit an Article program site an check für the programm tree
    Given that I am not logged in
    And default settings exists
    And the following "articles" exist:
      | title                        | url_name     | event_id | event_levels  | eventmoduletype |
      | "Programm"                   | programm     | 1        | 0             | program         |
    And the following "pricegroup" exist:
      | title                      | id |
      | Studenten                  |  1 |
      | Frühbucher                 |  2 |
      | Senioren                   |  3 |
      | VIP                        |  4 |
    And the following "events" exist:
      | title                      | parent_id | id | active | external_link | max_number_of_participators | type_of_event           | exclusive |
      | Cloudforum                 |           | 1  | 1      |               |  0                          | Registration needed     | 0         |
      | Cloudforum-Old             |           | 12 | 0      |               |  0                          | Registration needed     | 0         |
      | Kongress                   |  1        | 2  | 1      |               |  0                          | No Registration needed  | 0         |
      | Treffen der Generationen   |  1        | 3  | 1      |               |  0                          | No Registration needed  | 0         |
      | Party                      |  3        | 5  | 1      |               |  10                         | Registration needed     | 0         |
      | VIP-Party                  |  3        | 13 | 1      |               |  10                         | Registration needed     | 0         |
      | Rede                       |  2        | 6  | 1      |               |  0                          | No Registration needed  | 0         |
      | Party2                     |  2        | 7  | 1      |               |  0                          | Registration needed     | 0         |
      | Rede 2                     |  2        | 8  | 1      |               |  0                          | No Registration needed  | 0         |
      | VIP Einzelgespräch         |  8        | 9  | 1      |               |  0                          | No Registration needed  | 0         |
      | Exclusives Abendessen      |  3        | 11 | 1      |               |  0                          | No Registration needed  | 1         |
      | Abendessen Alternative 2   |  11       | 10 | 1      |               |  0                          | Registration needed     | 0         |
      | Abendessen Alternative 1   |  11       | 4  | 1      |               |  0                          | Registration needed     | 0         |
    And the following "event_pricegroups" exist:
      | id | event_id | pricegroup_id | price | max_number_of_participators | available | start_reservation     | cancelation_until     | end_reservation       | webcode |
      | 5  |        5 |             1 |  50.0 |                         500 |      true | "2012-02-10 12:00:00" | "2012-04-01 12:00:00" | "2012-03-01 12:00:00" |         |
      | 6  |        5 |             2 |  30.0 |                         200 |      true | "2012-02-01 12:00:00" | "2012-04-01 12:00:00" | "2012-02-09 12:00:00" |         |
      | 7  |       10 |             3 |  80.0 |                         100 |      true | "2012-02-01 12:00:00" | "2012-04-01 12:00:00" | "2012-02-09 12:00:00" |         |
      | 8  |        1 |             1 |  80.0 |                         500 |      true | "2012-02-01 12:00:00" | "2012-04-01 12:00:00" | "2012-02-09 12:00:00" |         |
      | 9  |       13 |             4 |  0.0  |                         100 |      true | "2012-02-01 12:00:00" | "2012-04-01 12:00:00" | "2012-02-09 12:00:00" | OSTERN  |
  When I visit url "/programm"   
  Then I should not see "Cloudforum"
  And I should not see "Cloudforum-Old"
  And I should see "Kongress"
  And I should see "Treffen der Generationen"
  And I should see "Party"
  And I should see "VIP-Party"
  And I should see "Rede"
  And I should see "Party2"
  And I should see "Rede 2"
  And I should see "VIP Einzelgespräch"
  And I should see "Exclusives Abendessen"
  And I should see "Abendessen Alternative 2"
  And I should see "Abendessen Alternative 1"
  
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
    Then I select "Studenten" within ".pricegroup_pricegroup" 
    And I should see "Price"
    And I fill in "Price" with "10.5"
    Then I press "Update Event"
    And I should see "Studenten"
    # And I should see "10.50" findet den Inhalt nicht, da es kein String ist, sondern Value in einem Input
    
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
    # And I should see "Osterspezial2010" findet den Inhalt nicht, da es kein String ist, sondern Value in einem Input

  @javascript
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
    And I remove jquery chosen
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

  @javascript
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
    And I remove jquery chosen
    And I select "Audi Deutschland" within "#event_sponsors_input"
    Then I press "Update Event"
    And I should see "Audi Deutschland"

  @javascript
  Scenario: Set artists for an event
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    And the following events exist:
      | title                        | parent_id | id | active |
      | "Event1"                     |           |  1 | true   |
   And the following artists exist:
      | title             | description | id |
      | "Bodo Wartke"     | "toll toll" |  1 |
      | "Mario Barth"     | "Kuenstler" |  2 |
    When I go to the admin list of events
    Then I click on "Edit" within "tr#event_1"
    And I remove jquery chosen
    And I select "Bodo Wartke" within "#event_artists_input"
    And I select "Mario Barth" within "#event_artists_input"
    And I press "Update Event"
    Then I should see "Bodo Wartke"
    And I should see "Mario Barth"
