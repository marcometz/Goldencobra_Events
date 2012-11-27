Feature: See and register events
  In order to visit an event
  As an guest
  I want to see a programm select some options and register myself for an event

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
      | Cloudforum-Old             |           | 12 | 0      |               |  0                          | Registration needed     | false      |
      | Kongress                   |  1        | 2  | 1      |               |  0                          | No Registration needed  | false      |
      | Treffen der Generationen   |  1        | 3  | 1      |               |  0                          | No Registration needed  | false      |
      | Party                      |  3        | 5  | 1      |               |  10                         | Registration needed     | false      |
      | VIP-Party                  |  3        | 13 | 1      |               |  10                         | Registration needed     | false      |
      | Rede                       |  2        | 6  | 1      |               |  0                          | No Registration needed  | false      |
      | Party2                     |  2        | 7  | 1      |               |  10                         | Registration optional   | false      |
      | Rede 2                     |  2        | 8  | 1      |               |  0                          | No Registration needed  | false      |
      | VIP Einzelgespräch         |  8        | 9  | 1      |               |  0                          | No Registration needed  | false      |
      | Exclusives Abendessen      |  3        | 11 | 1      |               |  0                          | No Registration needed  | true       |
      | Abendessen Alternative 2   |  11       | 10 | 1      |               |  0                          | Registration needed     | false      |
      | Abendessen Alternative 1   |  11       | 4  | 1      |               |  0                          | Registration needed     | false      |
    And no "GoldencobraEvents::EventPricegroup" exist
    And the following "event_pricegroups" exist:
     | id | event_id | pricegroup_id | price | max_number_of_participators | available | start_reservation     | cancelation_until     | end_reservation       | webcode  |
     |  5 |        5 |             1 |  50.0 |                         500 |      true | "2012-02-10 12:00:00" | "2012-04-01 12:00:00" | "2013-03-01 12:00:00" |          |
     |  6 |        5 |             2 |  30.0 |                         200 |      true | "2012-02-01 12:00:00" | "2012-04-01 12:00:00" | "2013-02-09 12:00:00" |          |
     |  7 |       10 |             3 |  80.0 |                         100 |      true | "2012-02-01 12:00:00" | "2012-04-01 12:00:00" | "2013-02-09 12:00:00" |          |
     |  8 |        1 |             1 |  80.0 |                         500 |      true | "2012-02-01 12:00:00" | "2012-04-01 12:00:00" | "2013-02-09 12:00:00" |          |
     |  9 |       1  |             3 |  0.0  |                         100 |      true | "2012-02-01 12:00:00" | "2012-12-01 12:00:00" | "2013-02-09 12:00:00" | OSTERN |

#  @javascript
#  Scenario: Go to the program site and look for events, enter a webcode and see 1 more event
#    When I go to the article page "anmeldung"
#    Then I should see "Sofern Sie einen Webcode besitzen, geben Sie diesen hier bitte an."
#    And I should not see "Webcode: OSTERN"
#    And I should not see "Senioren"
#    When I fill in "webcode" with "falscher Webcode"
#    And I press "Weiter"
#    And show me the page
#    Then I should see "Webcode ist nicht gültig"
#    When I fill in "webcode" with "OSTERN"
#    And I press "Weiter"
#    And I should see "Webcode ist gültig"
#    And I should see "Senioren"

  @javascript
  Scenario: Go to the registration site and see brutto and netto prices
    When I go to the article page "anmeldung"
    Then I should see "80,00"
    And I should see "(brutto: 95,20 €)"

  @javascript
  Scenario: Go to the program site and look for events with an url parameter and see all events
    When I visit url "/anmeldung?webcode=OSTERN"
    #Then I should not see "Sofern Sie einen Webcode besitzen, geben Sie diesen hier bitte an."
    And I should see "VIP-Party"
    And I should not see "VIP Einzelgespräch"

  @javascript
  Scenario: Got to the program site and register for events and panels
    When I visit url "/anmeldung"
    Then I should see "Studenten"
    And I choose "Studenten"
    And I press "Weiter"
    And I click on "Mit Anmeldung fortfahren" within "#goldencobra_events_enter_account_data_wrapper"
    Then the text "Bitte füllen Sie Ihre Benutzerdaten aus" should be visible
    And I choose "male"
    And I fill in "registration_user_firstname" with "Holger"
    And I fill in "registration_user_lastname" with "Frohloff"
    And I fill in "registration_company_location_attributes_street" with "Zossener Str. 55"
    And I fill in "registration_company_location_attributes_zip" with "10961"
    And I fill in "registration_company_location_attributes_city" with "Berlin"
    And I fill in "registration_user_email" with "holger@ikusei.de"
    And I check "AGB_accepted"
    And I choose "no"
    And I press "Verbindlich bestellen"
    And I should see "Zusammenfassung"
    And I should see "Herr"
    And I should see "Holger"
    And I should see "Frohloff"
    And I should see "Zossener Str. 55"
    And I should see "10961"
    And I should see "Berlin"
    And I should see "80,00"
    And I should see "Ändern"
    And I press "Verbindlich bestellen"
    And I should see "Anmeldung erfolgreich abgeschlossen"

  @javascript
  Scenario: Got to the program site and try to register twice for events and panels
    When I visit url "/anmeldung"
    Then I should see "Studenten"
    And I choose "Studenten"
    And I press "Weiter"
    And I click on "Mit Anmeldung fortfahren" within "#goldencobra_events_enter_account_data_wrapper"
    Then the text "Bitte füllen Sie Ihre Benutzerdaten aus" should be visible
    And I choose "female"
    And I fill in "registration_user_firstname" with "Andrea"
    And I fill in "registration_user_lastname" with "Testfrau"
    And I fill in "registration_company_location_attributes_street" with "Zossener Str. 55"
    And I fill in "registration_company_location_attributes_zip" with "10961"
    And I fill in "registration_company_location_attributes_city" with "Berlin"
    And I fill in "registration_user_email" with "holger@ikusei.de"
    And I check "AGB_accepted"
    And I choose "no"
    And I press "Verbindlich bestellen"
    And I should see "Zusammenfassung"
    And I should see "Frau"
    And I should see "Andrea Testfrau"
    And I press "Verbindlich bestellen"
    And I should see "Anmeldung erfolgreich abgeschlossen"
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    When I go to the admin list of applicants
    Then I should see "holger@ikusei.de"
    And the count of elements "span.email" should be "1"

  @javascript
  Scenario: Got to the program site and register for events and panels with alternate billing address
    When I visit url "/anmeldung"
    Then I should see "Studenten"
    And I choose "Studenten"
    And I press "Weiter"
    And I click on "Mit Anmeldung fortfahren" within "#goldencobra_events_enter_account_data_wrapper"
    Then the text "Bitte füllen Sie Ihre Benutzerdaten aus" should be visible
    And I choose "male"
    And I fill in "registration_user_firstname" with "Holger"
    And I fill in "registration_user_lastname" with "Frohloff"
    And I fill in "registration_company_location_attributes_street" with "Musterstr. 55"
    And I fill in "registration_company_location_attributes_zip" with "10962"
    And I fill in "registration_company_location_attributes_city" with "Berlin"
    And I fill in "registration_user_email" with "holger@ikusei.de"
    And I choose "yes"
    And I choose "billing_male"
    And I fill in "registration_billing_user_billing_firstname" with "Philipp"
    And I fill in "registration_billing_user_billing_lastname" with "Wilimzig"
    And I fill in "registration_billing_company_title" with "ikusei GmbH"
    And I fill in "registration_billing_company_location_attributes_street" with "Zossener Str. 55"
    And I fill in "registration_billing_company_location_attributes_zip" with "10961"
    And I fill in "registration_billing_company_location_attributes_city" with "Berlin"

    And I check "AGB_accepted"
    And I press "Verbindlich bestellen"
    And I should see "Zusammenfassung"
    And I should see "Holger"
    And I should see "Frohloff"
    And I should see "Musterstr. 55"
    And I should see "10962"
    And I should see "Berlin"
    And I should see "80,00"
    And I should see "Ändern"
    And I should see "Rechnungsanschrift"
    And I should see "Herr"
    And I should see "Philipp Wilimzig"
    And I should see "ikusei GmbH"
    And I should see "Zossener Str. 55"
    And I should see "10961"
    And I should see "Berlin"

    And I press "Verbindlich bestellen"
    And I should see "Anmeldung erfolgreich abgeschlossen"

   # @wip
    @javascript
    Scenario: Got to the program site and try to register with wrong values
      When I visit url "/anmeldung"
      Then I should see "Studenten"
      And I choose "Studenten"
      And I press "Weiter"
      # And I choose "Party2"
      # And I click on "register_for_event_7_link"
      And I click on "Mit Anmeldung fortfahren" within "#goldencobra_events_enter_account_data_wrapper"
      And I should see "Bitte füllen Sie Ihre Benutzerdaten aus"
      And I choose "male"
      And I fill in "registration_user_firstname" with "Holger"
      And I fill in "registration_user_lastname" with "Frohloff"
      And I fill in "registration_company_location_attributes_street" with "Zossener Str. 55"
      And I fill in "registration_company_location_attributes_zip" with "abc"
      And I fill in "registration_company_location_attributes_city" with "Berlin"
      And I fill in "registration_user_email" with "holger@"
      And I check "AGB_accepted"
      And I choose "no"
      And I press "Verbindlich bestellen"
      And I should see "Pflichtangabe. Bitte 5 stellige Postleitzahl angeben."
      And I fill in "registration_company_location_attributes_zip" with "10961"
      And I fill in "registration_user_email" with "holger@ikusei.de"
      And I press "Verbindlich bestellen"
      And I should see "Zusammenfassung"
      # And I should see "Party2"
      And I should see "Holger"
      And I should see "Frohloff"
      And I should see "Zossener Str. 55"
      And I should see "10961"
      And I should see "Berlin"
      And I should see "80,00"
      #And I should see "Abendessen Alternative 1"
      And I should see "Ändern"
      And I press "Verbindlich bestellen"
      And I should see "Anmeldung erfolgreich abgeschlossen"
      #And "holger@ikusei.de" should receive an email


    @javascript
    Scenario: Got to the program site and try to register with wrong email format
      When I visit url "/anmeldung"
      Then I should see "Studenten"
      And I choose "Studenten"
      And I press "Weiter"
      And I click on "Mit Anmeldung fortfahren" within "#goldencobra_events_enter_account_data_wrapper"
      And I should see "Bitte füllen Sie Ihre Benutzerdaten aus"
      And I choose "male"
      And I fill in "registration_user_firstname" with "Holger"
      And I fill in "registration_user_lastname" with "Frohloff"
      And I fill in "registration_company_location_attributes_street" with "Zossener Str. 55"
      And I fill in "registration_company_location_attributes_zip" with "12345"
      And I fill in "registration_company_location_attributes_city" with "Berlin"
      And I fill in "registration_user_email" with "holger@test.de (Test)"
      And I check "AGB_accepted"
      And I choose "no"
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
      And I should see "Ändern"
      And I press "Verbindlich bestellen"
      And I should see "Anmeldung erfolgreich abgeschlossen"
      #And "holger@ikusei.de" should receive an email

