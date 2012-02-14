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
      | title                        | id |
      | "Studenten"                  |  1 |
      | "Frühbucher"                 |  2 |
    And the following "events" exist:
      | title                        | parent_id | id | active | external_link | max_number_of_participators | type_of_event            | exclusive |
      | "Cloudforum"                 |           | 1  | 1      |               |  0                          | No Registration needed  | 0         |
      | "Kongress"                   |  1        | 2  | 1      |               |  0                          | No Registration needed  | 0         |
      | "Treffen der Generationen"   |  1        | 3  | 1      |               |  0                          | No Registration needed  | 0         |
      | "Party"                      |  3        | 5  | 1      |               |  0                          | Registration needed     | 0         |
      | "Rede"                       |  2        | 6  | 1      |               |  0                          | No Registration needed  | 0         |
      | "Party2"                     |  2        | 7  | 1      |               |  0                          | Registration needed     | 0         |
      | "Rede 2"                     |  2        | 8  | 1      |               |  0                          | No Registration needed  | 0         |
      | "VIP Einzelgespräch"         |  8        | 9  | 1      |               |  0                          | Private event           | 0         |
      | "Exclusives Abendessen"      |  3        | 11 | 1      |               |  0                          | No Registration needed  | 1         |
      | "Abendessen Alternative 2"   |  11       | 10 | 1      |               |  0                          | Registration needed     | 0         |
      | "Abendessen Alternative 1"   |  11       | 4  | 1      |               |  0                          | Registration needed     | 0         |
    And the following "event_pricegroups" exist:
      | event_id | pricegroup_id | price | max_number_of_participators | available | start_reservation     | cancelation_until     | end_reservation       |
      |        5 |             1 |  50.0 |                         500 |      true | "2012-02-10 12:00:00" | "2012-04-01 12:00:00" | "2012-03-01 12:00:00" |  
      |        5 |             2 |  30.0 |                         200 |      true | "2012-02-01 12:00:00" | "2012-04-01 12:00:00" | "2012-02-09 12:00:00" |  

  @javascript
  Scenario: Go to the program site and look for events
    When I go to the article page "programm"
    Then I should see "Cloudforum"
    And I should see "Kongress"
    And I should see "Party"
    And I should see "Treffen der Generationen"
    And I should see "Party2"
    And I should see "Anmelden" within ".register_for_event_5"
    When I click on "Anmelden" within ".register_for_event_5"
    #Then I should see ""
    
    
  Scenario: Go to the admin sites and look for registrations
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    When I go to the admin list of registrations
    Then I should see "Registrations" within "h2"
    