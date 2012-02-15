Feature: See and register events
  In order to visit an event
  As an guest
  I want to see a programm an register myself for an event

  Background:
    Given that I am not logged in
    And the following "articles" exist:
      | title                        | url_name     | event_id | event_levels  |
      | "Programm"                   | programm     | 1        | 0             |
    And the following "pricegroup" exist:
      | title                      | id |
      | Studenten                  |  1 |
      | Frühbucher                 |  2 |
      | Senioren                   |  3 |
    And the following "events" exist:
      | title                      | parent_id | id | active | external_link | max_number_of_participators | type_of_event           | exclusive |
      | Cloudforum                 |           | 1  | 1      |               |  0                          | Registration needed     | 0         |
      | Cloudforum-Old             |           | 12 | 0      |               |  0                          | Registration needed     | 0         |
      | Kongress                   |  1        | 2  | 1      |               |  0                          | No Registration needed  | 0         |
      | Treffen der Generationen   |  1        | 3  | 1      |               |  0                          | No Registration needed  | 0         |
      | Party                      |  3        | 5  | 1      |               |  10                         | Registration needed     | 0         |
      | Rede                       |  2        | 6  | 1      |               |  0                          | No Registration needed  | 0         |
      | Party2                     |  2        | 7  | 1      |               |  0                          | Registration needed     | 0         |
      | Rede 2                     |  2        | 8  | 1      |               |  0                          | No Registration needed  | 0         |
      | VIP Einzelgespräch         |  8        | 9  | 1      |               |  0                          | Private event           | 0         |
      | Exclusives Abendessen      |  3        | 11 | 1      |               |  0                          | No Registration needed  | 1         |
      | Abendessen Alternative 2   |  11       | 10 | 1      |               |  0                          | Registration needed     | 0         |
      | Abendessen Alternative 1   |  11       | 4  | 1      |               |  0                          | Registration needed     | 0         |
    And the following "event_pricegroups" exist:
      | id | event_id | pricegroup_id | price | max_number_of_participators | available | start_reservation     | cancelation_until     | end_reservation       |
      | 5  |        5 |             1 |  50.0 |                         500 |      true | "2012-02-10 12:00:00" | "2012-04-01 12:00:00" | "2012-03-01 12:00:00" |  
      | 6  |        5 |             2 |  30.0 |                         200 |      true | "2012-02-01 12:00:00" | "2012-04-01 12:00:00" | "2012-02-09 12:00:00" |  
      | 7  |       10 |             3 |  80.0 |                         100 |      true | "2012-02-01 12:00:00" | "2012-04-01 12:00:00" | "2012-02-09 12:00:00" |  
      | 8  |        1 |             1 |  80.0 |                         500 |      true | "2012-02-01 12:00:00" | "2012-04-01 12:00:00" | "2012-02-09 12:00:00" |  

  @javascript
  Scenario: Go to the program site and look for events
    When I go to the article page "programm"
    Then I should see "Cloudforum"
    And I should not see "Cloudforum-Old"
    And I should see "Kongress"
    And I should see "Party"
    And I should see "Treffen der Generationen"
    And I should see "Party2"
    And I should see "register_text" within ".register_for_event_5"
    When I click on "register_text" within ".register_for_event_5"
    Then I should see "Studenten" within "#goldencobra_events_event_popup"
    And I should see "50" within ".goldencobra_events_event_price_group_item_for_select_5"
    And I should not see "30" within ".goldencobra_events_event_price_group_item_for_select_5"
    And I should see "Frühbucher" within "#goldencobra_events_event_popup"
    And I should see "30" within ".goldencobra_events_event_price_group_item_for_select_6"
    And I should not see "Senioren" within "#goldencobra_events_event_popup"
    When I choose "event_event_pricegroup_5" within "#goldencobra_events_event_popup"
    And I press "Absenden"
    Then I should see "Dieser Event wurde zu Ihrer Buchungsliste hinzugefügt"
    And I should see "Party" within "#goldencobra_events_registration_basket"
    When I should see "register_text" within ".register_for_event_10"
    And I click on "register_text" within ".register_for_event_10"
    Then I should see "Dieser Event wurde zu Ihrer Buchungsliste hinzugefügt"
    And I should see "Abendessen Alternative 2" within "#goldencobra_events_registration_basket"
    

  @javascript
  Scenario: Go to the program site and register for the main event
    When I go to the article page "programm"
    Then I should see "Cloudforum"
    And I should see "register_text" within ".register_for_event_1"
    When I click on "register_text" within ".register_for_event_1"
    Then I should see "Dieser Event wurde zu Ihrer Buchungsliste hinzugefügt"
    And I should see "Cloudforum" within "#goldencobra_events_registration_basket"

  @javascript
  Scenario: Go to the program site and register first for the main event and then for an subevent
    When I go to the article page "programm"
    Then I should see "Cloudforum"
    And I should see "register_text" within ".register_for_event_1"
    When I click on "register_text" within ".register_for_event_1"
    Then I should see "Dieser Event wurde zu Ihrer Buchungsliste hinzugefügt"
    And I should see "Cloudforum" within "#goldencobra_events_registration_basket"
    When I click on "close" within "#goldencobra_events_event_popup"
    When I should see "register_text" within ".register_for_event_10"
    And I click on "register_text" within ".register_for_event_10"
    Then I should see "Dieser Event wurde zu Ihrer Buchungsliste hinzugefügt"
    When I click on "close" within "#goldencobra_events_event_popup"
    And I should see "Cloudforum" within "#goldencobra_events_registration_basket"
    And I should see "Abendessen Alternative 2" within "#goldencobra_events_registration_basket"

  @javascript
  Scenario: Go to the program site, add the main event, then add a subevent, then remove the main event
    When I go to the article page "programm"
    Then I should see "Cloudforum"
    And I should see "register_text" within ".register_for_event_1"
    When I click on "register_text" within ".register_for_event_1"
    Then I should see "Dieser Event wurde zu Ihrer Buchungsliste hinzugefügt"
    And I should see "Cloudforum" within "#goldencobra_events_registration_basket"
    When I should see "register_text" within ".register_for_event_10"
    And I click on "register_text" within ".register_for_event_10"
    Then I should see "Dieser Event wurde zu Ihrer Buchungsliste hinzugefügt"
    And I should see "Cloudforum" within "#goldencobra_events_registration_basket"
    And I should see "Abendessen Alternative 2" within "#goldencobra_events_registration_basket"
    When I go to the article page "programm"
    And I should see "Cloudforum" within "#goldencobra_events_registration_basket"
    And I should see "Abendessen Alternative 2" within "#goldencobra_events_registration_basket"
    Then I click on "remove_text" within "#goldencobra_events_registration_basket_item_8"
    And I should not see "Cloudforum" within "#goldencobra_events_registration_basket"
    And I should not see "Abendessen Alternative 2" within "#goldencobra_events_registration_basket"


  @javascript
  Scenario: Go to the program site, add the main event, then add a subevent, then remove the subevent
    When I go to the article page "programm"
    Then I should see "Cloudforum"
    And I should see "register_text" within ".register_for_event_1"
    When I click on "register_text" within ".register_for_event_1"
    Then I should see "Dieser Event wurde zu Ihrer Buchungsliste hinzugefügt"
    When I go to the article page "programm"
    And I should see "Cloudforum" within "#goldencobra_events_registration_basket"
    When I should see "register_text" within ".register_for_event_10"
    And I click on "register_text" within ".register_for_event_10"
    Then I should see "Dieser Event wurde zu Ihrer Buchungsliste hinzugefügt"
    When I go to the article page "programm"
    And I should see "Cloudforum" within "#goldencobra_events_registration_basket"
    And I should see "Abendessen Alternative 2" within "#goldencobra_events_registration_basket"
    When I click on "remove_text" within "#goldencobra_events_registration_basket_item_7"
    And I should see "Cloudforum" within "#goldencobra_events_registration_basket"
    And I should not see "Abendessen Alternative 2" within "#goldencobra_events_registration_basket"


  #@javascript
  #Scenario: Go to the program site,  add a subevent, and parrent events should be to add as an mandatory option
  #  When I go to the article page "programm"
  #  And I should see "register_text" within ".register_for_event_10"
  #  And I click on "register_text" within ".register_for_event_10"
  #  Then I should be asked to make register for parent event
  #  And I should see "Cloudforum" within "#goldencobra_events_registration_basket"
  #  And I should see "Abendessen Alternative 2" within "#goldencobra_events_registration_basket"

    
  Scenario: Go to the admin sites and look for registrations
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    When I go to the admin list of registrations
    Then I should see "Registrations" within "h2"
    