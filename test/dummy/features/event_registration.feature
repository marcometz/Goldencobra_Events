Feature: See and register events
  In order to visit an event
  As an guest
  I want to see a programm an register myself for an event

  Background:
    Given that I am not logged in
    And default settings exists
    And the following "articles" exist:
      | title                        | url_name     | event_id | event_levels  | eventmoduletype |
      | "Anmeldung"                  | anmeldung    | 1        | 0             | registration    |
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


  @javascript
  Scenario: Go to the program site and look for events, enter a webcode and see 1 more event
    When I go to the article page "anmeldung"
    Then I should see "Webcode eingeben"
    And I should not see "Webcode: OSTERN"
    And I should not see "VIP-Party"
    When I fill in "webcode" with "falscher Webcode"
    And I press "absenden"
    Then I should see "Der eingegebene Webcode ist ungültig"
    When I fill in "webcode" with "OSTERN"
    And I press "absenden"
    Then I should see "Webcode ist gültig: OSTERN"
    And I should not see "Der eingegebene Webcode ist ungültig"
    And I should see "VIP-Party"  

  @javascript
  Scenario: Go to the program site and look for events with an url parameter and see all events
    When I visit url "/anmeldung?webcode=OSTERN"
    Then I should not see "Webcode eingeben"
    And I should see "Webcode: OSTERN"
    And I should see "VIP-Party"
    And I should not see "VIP Einzelgespräch"

  @javascript
  Scenario: Go to the program site and and register some events
    When I visit url "/anmeldung?webcode=OSTERN"
    Then I should see "Cloudforum"
    And I should see "Anmelden"
    And I should not see "Kongress"
    When I click on "Anmelden" within "#register_for_event_1"
    Then I should see "Anmeldung vorgemerkt"
    And I should see "Party"
    And I should see "Party2"
    And the text "Party2" should be visible
    And the text "Party" should be visible    
    And I should not see "Treffen der Generationen"
    And the text "Abendessen Alternative 1" should be visible
    And the text "Abendessen Alternative 2" should be visible     
    And the text "Bitte wählen Sie zwischen einer dieser Optionen" should be visible 
    When I click on "Anmelden" within "#register_for_event_7"
    Then I should see "Anmeldung vorgemerkt" within "div#register_for_event_7" 
    When I click on "Anmelden" within "#register_for_event_5"
    Then I should see "Dieser Event besitzt mehrere Preisgruppen zur Auswahl"
    
     
     
     
     
     
     
     
     
     
     
     
     
 #   Then I should see "Cloudforum"
 #   And I should not see "Cloudforum-Old"
 #   And I should see "Kongress"
 #   And I should see "Party"
 #   And I should see "Treffen der Generationen"
 #   And I should see "Party2"
 #   And I should see "Anmelden" within ".register_for_event_5"
 #   When I click on "Anmelden" within ".register_for_event_5"
 #   Then I should see "Studenten" within "#goldencobra_events_event_popup"
 #   And I should see "50" within ".goldencobra_events_event_price_group_item_for_select_5"
 #   And I should not see "30" within ".goldencobra_events_event_price_group_item_for_select_5"
 #   And I should see "Frühbucher" within "#goldencobra_events_event_popup"
 #   And I should see "30" within ".goldencobra_events_event_price_group_item_for_select_6"
 #   And I should not see "Senioren" within "#goldencobra_events_event_popup"
 #   When I choose "event_event_pricegroup_5" within "#goldencobra_events_event_popup"
 #   And I press "goldencobra_events_registration_to_add_submit"
 #   Then I should see "Dieser Event wurde zu Ihrer Buchungsliste hinzugefügt"
 #   And I should see "Party" within "#goldencobra_events_registration_basket"
 #   When I should see "Anmelden" within ".register_for_event_10"
 #   And I click on "Anmelden" within ".register_for_event_10"
 #   Then I should see "Dieser Event wurde zu Ihrer Buchungsliste hinzugefügt"
 #   And I should see "Abendessen Alternative 2" within "#goldencobra_events_registration_basket"
 #   
 #
 # @javascript
 # Scenario: Go to the program site and register for the main event
 #   When I go to the article page "programm"
 #   Then I should see "Cloudforum"
 #   And I should see "Anmelden" within ".register_for_event_1"
 #   When I click on "Anmelden" within ".register_for_event_1"
 #   Then I should see "Dieser Event wurde zu Ihrer Buchungsliste hinzugefügt"
 #   And I should see "Cloudforum" within "#goldencobra_events_registration_basket"
 #
 # @javascript
 # Scenario: Go to the program site and register first for the main event and then for an subevent
 #   When I go to the article page "programm"
 #   Then I should see "Cloudforum"
 #   And I should see "Anmelden" within ".register_for_event_1"
 #   When I click on "Anmelden" within ".register_for_event_1"
 #   Then I should see "Dieser Event wurde zu Ihrer Buchungsliste hinzugefügt"
 #   And I should see "Cloudforum" within "#goldencobra_events_registration_basket"
 #   When I click on "close" within "#goldencobra_events_event_popup"
 #   When I should see "Anmelden" within ".register_for_event_10"
 #   And I click on "Anmelden" within ".register_for_event_10"
 #   Then I should see "Dieser Event wurde zu Ihrer Buchungsliste hinzugefügt"
 #   When I click on "close" within "#goldencobra_events_event_popup"
 #   And I should see "Cloudforum" within "#goldencobra_events_registration_basket"
 #   And I should see "Abendessen Alternative 2" within "#goldencobra_events_registration_basket"
 #
 # @javascript
 # Scenario: Go to the program site, add the main event, then add a subevent, then remove the main event
 #   When I go to the article page "programm"
 #   Then I should see "Cloudforum"
 #   And I should see "Anmelden" within ".register_for_event_1"
 #   When I click on "Anmelden" within ".register_for_event_1"
 #   Then I should see "Dieser Event wurde zu Ihrer Buchungsliste hinzugefügt"
 #   And I should see "Cloudforum" within "#goldencobra_events_registration_basket"
 #   When I should see "Anmelden" within ".register_for_event_10"
 #   And I click on "Anmelden" within ".register_for_event_10"
 #   Then I should see "Dieser Event wurde zu Ihrer Buchungsliste hinzugefügt"
 #   And I should see "Cloudforum" within "#goldencobra_events_registration_basket"
 #   And I should see "Abendessen Alternative 2" within "#goldencobra_events_registration_basket"
 #   When I go to the article page "programm"
 #   And I should see "Cloudforum" within "#goldencobra_events_registration_basket"
 #   And I should see "Abendessen Alternative 2" within "#goldencobra_events_registration_basket"
 #   Then I click on "entfernen" within "#goldencobra_events_registration_basket_item_8"
 #   And I should not see "Cloudforum" within "#goldencobra_events_registration_basket"
 #   And I should not see "Abendessen Alternative 2" within "#goldencobra_events_registration_basket"
 #
 #
 # @javascript
 # Scenario: Go to the program site, add the main event, then add a subevent, then remove the subevent
 #   When I go to the article page "programm"
 #   Then I should see "Cloudforum"
 #   And I should see "Anmelden" within ".register_for_event_1"
 #   When I click on "Anmelden" within ".register_for_event_1"
 #   Then I should see "Dieser Event wurde zu Ihrer Buchungsliste hinzugefügt"
 #   When I go to the article page "programm"
 #   And I should see "Cloudforum" within "#goldencobra_events_registration_basket"
 #   When I should see "Anmelden" within ".register_for_event_10"
 #   And I click on "Anmelden" within ".register_for_event_10"
 #   Then I should see "Dieser Event wurde zu Ihrer Buchungsliste hinzugefügt"
 #   When I go to the article page "programm"
 #   And I should see "Cloudforum" within "#goldencobra_events_registration_basket"
 #   And I should see "Abendessen Alternative 2" within "#goldencobra_events_registration_basket"
 #   When I click on "entfernen" within "#goldencobra_events_registration_basket_item_7"
 #   And I should see "Cloudforum" within "#goldencobra_events_registration_basket"
 #   And I should not see "Abendessen Alternative 2" within "#goldencobra_events_registration_basket"
 #
 #
 # #@javascript
 # #Scenario: Go to the program site,  add a subevent, and parrent events should be to add as an mandatory option
 # #  When I go to the article page "programm"
 # #  And I should see "Anmelden" within ".register_for_event_10"
 # #  And I click on "Anmelden" within ".register_for_event_10"
 # #  Then I should be asked to make register for parent event
 # #  And I should see "Cloudforum" within "#goldencobra_events_registration_basket"
 # #  And I should see "Abendessen Alternative 2" within "#goldencobra_events_registration_basket"
 #   
 #   
 # Scenario: Go to the admin sites and look for registrations
 #   Given that a confirmed admin exists
 #   And I am logged in as "admin@test.de" with password "secure12"
 #   And the following "guest_users" exist:
 #     | id | email         | password  | password_confirmation | firstname | lastname |
 #     |  2 | test1@test.de | 123456ABC | 123456ABC             | Tim       | Test     |
 #     |  3 | test2@test.de | 123456ABC | 123456ABC             | Tina      | Test     |
 #   And the following "event_registrations" exist:
 #     | id | event_pricegroup_id | user_id |
 #     |  1 |                   5 |       2 |
 #     |  2 |                   8 |       2 |
 #     |  3 |                   6 |       3 |
 #     |  4 |                   5 |       3 |
 #     |  5 |                   7 |       3 |
 #   When I go to the admin list of applicants
 #   
 #   
