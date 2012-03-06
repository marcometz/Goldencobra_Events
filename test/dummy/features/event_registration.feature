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
      | Cloudforum                 |           | 1  | 1      |               |  0                          | Registration needed     | false      |
      | Cloudforum-Old             |           | 12 | 0      |               |  0                          | Registration needed     | false      |
      | Kongress                   |  1        | 2  | 1      |               |  0                          | No Registration needed  | false      |
      | Treffen der Generationen   |  1        | 3  | 1      |               |  0                          | No Registration needed  | false      |
      | Party                      |  3        | 5  | 1      |               |  10                         | Registration needed     | false      |
      | VIP-Party                  |  3        | 13 | 1      |               |  10                         | Registration needed     | false      |
      | Rede                       |  2        | 6  | 1      |               |  0                          | No Registration needed  | false      |
      | Party2                     |  2        | 7  | 1      |               |  0                          | Registration needed     | false      |
      | Rede 2                     |  2        | 8  | 1      |               |  0                          | No Registration needed  | false      |
      | VIP Einzelgespräch         |  8        | 9  | 1      |               |  0                          | No Registration needed  | false      |
      | Exclusives Abendessen      |  3        | 11 | 1      |               |  0                          | No Registration needed  | true       |
      | Abendessen Alternative 2   |  11       | 10 | 1      |               |  0                          | Registration needed     | false      |
      | Abendessen Alternative 1   |  11       | 4  | 1      |               |  0                          | Registration needed     | false      |
    And the following "event_pricegroups" exist:
      | event_id | pricegroup_id | price | max_number_of_participators | available | start_reservation     | cancelation_until     | end_reservation       | webcode |
      |        5 |             1 |  50.0 |                         500 |      true | "2012-02-10 12:00:00" | "2012-04-01 12:00:00" | "2012-03-01 12:00:00" |         |
      |        5 |             2 |  30.0 |                         200 |      true | "2012-02-01 12:00:00" | "2012-04-01 12:00:00" | "2012-02-09 12:00:00" |         |
      |       10 |             3 |  80.0 |                         100 |      true | "2012-02-01 12:00:00" | "2012-04-01 12:00:00" | "2012-02-09 12:00:00" |         |
      |        1 |             1 |  80.0 |                         500 |      true | "2012-02-01 12:00:00" | "2012-04-01 12:00:00" | "2012-02-09 12:00:00" |         |
      |       13 |             4 |  0.0  |                         100 |      true | "2012-02-01 12:00:00" | "2012-04-01 12:00:00" | "2012-02-09 12:00:00" | OSTERN  |


  @javascript
  Scenario: Go to the program site and look for events, enter a webcode and see 1 more event
    When I go to the article page "anmeldung"
    Then I should see "Sofern Sie einen Webcode besitzen, geben Sie diesen hier bitte an."
    And I should not see "Webcode: OSTERN"
    And show me the page
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
    Then I should not see "Sofern Sie einen Webcode besitzen, geben Sie diesen hier bitte an."
    And I should see "Webcode: OSTERN"
    And I should see "VIP-Party"
    And I should not see "VIP Einzelgespräch"

  @javascript
  Scenario: Go to the program site and register all events
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
    When I click on "Anmelden" within "#register_for_event_5"
    Then I should see "Dieser Event besitzt mehrere Preisgruppen zur Auswahl"
