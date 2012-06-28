Feature: See and register events without options
  In order to visit an event
  As an guest
  I want to see a programm and register myself for an event

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
    And no "GoldencobraEvents::Event" exist  
    And the following "events" exist:
      | title                      | parent_id | id | active | external_link | max_number_of_participators | type_of_event           | exclusive |
      | Cloudforum                 |           | 1  | 1      |               |  0                          | Registration needed     | false      |
      
    And no "GoldencobraEvents::EventPricegroup" exist  
    And the following "event_pricegroups" exist:
     | id | event_id | pricegroup_id | price | max_number_of_participators | available | start_reservation     | cancelation_until     | end_reservation       | webcode  |
     |  8 |        1 |             1 |  80.0 |                         500 |      true | "2012-02-01 12:00:00" | "2012-04-01 12:00:00" | "2013-02-09 12:00:00" |          |
     |  9 |        1 |             3 |  0.0  |                         100 |      true | "2012-02-01 12:00:00" | "2012-04-01 12:00:00" | "2013-02-09 12:00:00" | PRESSE   |
     
  @javascript
  Scenario: Go to the program site and look for events, enter a webcode and see 1 more event
    When I go to the article page "anmeldung"
    Then I should see "Sofern Sie einen Webcode besitzen, geben Sie diesen hier bitte an."
    And I should not see "Webcode: PRESSE"
    And I should not see "Senioren"
    When I fill in "webcode" with "falscher Webcode"
    And I press "Weiter"
    Then I should see "Webcode ist nicht gültig"
    When I fill in "webcode" with "PRESSE"
    And I press "Weiter"
    And I should see "Webcode ist gültig"
    And I should see "Senioren"  

  @javascript
  Scenario: Go to the registration site and see brutto and netto prices
    When I go to the article page "anmeldung"
    Then I should see "80,00"
    And I should see "(brutto: 95,20 €)"
  
  @javascript
  Scenario: Got to the program site and register for events and no panels are to select
    When I visit url "/anmeldung"
    Then I should see "Studenten"
    And I choose "Studenten"
    When I press "Weiter"
    Then the text "Bitte füllen Sie Ihre Benutzerdaten aus" should be visible
    And I choose "male"
    And I fill in "registration_user_firstname" with "Holger"
    And I fill in "registration_user_lastname" with "Frohloff"
    And I fill in "registration_company_location_attributes_street" with "Zossener Str. 55"
    And I fill in "registration_company_location_attributes_zip" with "10961"
    And I fill in "registration_company_location_attributes_city" with "Berlin"
    And I fill in "registration_user_email" with "holger@ikusei.de"
    And I check "AGB_accepted"
    And I press "Verbindlich bestellen"
    And I should see "Zusammenfassung"
    And I should see "Holger"
    And I should see "Frohloff"
    And I should see "Zossener Str. 55"
    And I should see "10961"
    And I should see "Berlin"
    And I should see "80,00"
    And I should see "Aendern"
    And I press "Verbindlich bestellen"
    And I should see "Anmeldung erfolgreich abgeschlossen"

  @javascript
  Scenario: Got to the program site and try to register with wrong values and no panels are to select
    When I visit url "/anmeldung"
    Then I should see "Studenten"
    And I choose "Studenten"
    When I press "Weiter"
    Then the text "Bitte füllen Sie Ihre Benutzerdaten aus" should be visible
    And I choose "male"
    And I fill in "registration_user_firstname" with "Holger"
    And I fill in "registration_user_lastname" with "Frohloff"
    And I fill in "registration_company_location_attributes_street" with "Zossener Str. 55"
    And I fill in "registration_company_location_attributes_zip" with "abc"
    And I fill in "registration_company_location_attributes_city" with "Berlin"
    And I fill in "registration_user_email" with "holger@"
    And I check "AGB_accepted"
    And I press "Verbindlich bestellen"
    And I should see "Pflichtangabe. Bitte 5 stellige Postleitzahl angeben."
    And I fill in "registration_company_location_attributes_zip" with "10961"
    And I fill in "registration_user_email" with "holger@ikusei.de"
    And I press "Verbindlich bestellen"
    And I should see "Zusammenfassung"
    And I should see "Holger"
    And I should see "Frohloff"
    And I should see "Zossener Str. 55"
    And I should see "10961"
    And I should see "Berlin"
    And I should see "80,00"
    And I should see "Aendern"
    And I press "Verbindlich bestellen"
    And I should see "Anmeldung erfolgreich abgeschlossen"
    
      
  @javascript
  Scenario: Got to the program site and try to register with wrong email format and no panels are to select
    When I visit url "/anmeldung"
    Then I should see "Studenten"
    And I choose "Studenten"
    When I press "Weiter"
    Then the text "Bitte füllen Sie Ihre Benutzerdaten aus" should be visible
    And I choose "male"
    And I fill in "registration_user_firstname" with "Holger"
    And I fill in "registration_user_lastname" with "Frohloff"
    And I fill in "registration_company_location_attributes_street" with "Zossener Str. 55"
    And I fill in "registration_company_location_attributes_zip" with "12345"
    And I fill in "registration_company_location_attributes_city" with "Berlin"
    And I fill in "registration_user_email" with "holger@test.de (Test)"
    And I check "AGB_accepted"
    And I press "Verbindlich bestellen"
    And I should see "Email nicht gültig"
    And I fill in "registration_user_email" with "holger@ikusei.de(test)"
    And I press "Verbindlich bestellen"
    And I should see "Email nicht gültig"
    And I fill in "registration_user_email" with "holger@ikusei.de{test}"
    And I press "Verbindlich bestellen"
    And I should see "Email nicht gültig"
    And I fill in "registration_user_email" with "holger @ikusei.de"
    And I press "Verbindlich bestellen"
    And I should see "Email nicht gültig"
    And I fill in "registration_user_email" with "holger.frohloff_privat@ikusei2-firma.de"
    And I press "Verbindlich bestellen"
    And I should see "Zusammenfassung"
    And I should see "Holger"
    And I should see "Frohloff"
    And I should see "Zossener Str. 55"
    And I should see "12345"
    And I should see "Berlin"
    And I should see "80,00"
    And I should see "Aendern"
    And I press "Verbindlich bestellen"
    And I should see "Anmeldung erfolgreich abgeschlossen"
    
  