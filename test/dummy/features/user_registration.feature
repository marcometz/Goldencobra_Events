Feature: See and register events
  In order to visit an event
  As an guest
  I want to see a programm an register myself for an event

  Background:
    Given that I am not logged in
    And default settings exists
    And the following "articles" exist:
      | title                        | url_name     | event_id | event_levels  |
      | "Anmeldung"                  | anmeldung    | 1        | 0             |
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
      | event_id | pricegroup_id | price | max_number_of_participators | available |
      |        5 |             1 |  50.0 |                         500 |      true |
      |        5 |             2 |  30.0 |                         200 |      true |
      |       10 |             3 |  80.0 |                         100 |      true |
      |        1 |             1 |  80.0 |                         500 |      true |

  @javascript
  Scenario: Go to the program site, add an event and complete registration with all data needed
    When I go to the article page "anmeldung"
#    And I should see "Anmelden" within ".register_for_event_1"
#    And I click on "Anmelden" within ".register_for_event_1"
#    Then I should see "Dieser Event wurde zu Ihrer Buchungsliste hinzugefügt"
#    And I go to the article page "programm"
#    And I should see "Cloudforum" within "#goldencobra_events_registration_basket"
#    And I should see "Anmeldung abschließen" within "#goldencobra_events_registration_basket"
#    Then I click on "Anmeldung abschließen"
#    And I should see "Bitte füllen Sie Ihre Benutzerdaten aus"
#    When I choose "male" within "#goldencobra_events_event_popup"
#    And I fill in "registration_user_title" with "Dr."
#    And I fill in "registration_user_firstname" with "Tim"
#    And I fill in "registration_user_lastname" with "Test"
#    And I fill in "registration_user_function" with "Developer"
#    And I fill in "registration_user_email" with "tim.test@tester.de"
#    And I fill in "registration_user_phone" with "030755667523"
#    And I fill in "registration_user_fax" with "030755667529"
#    Then I click on "Detailinformationen"
#    When I fill in "registration_user_facebook" with "facebook_id"
#    And I fill in "registration_user_twitter" with "marcometz"
#    And I fill in "registration_user_linkedin" with "myLinkdid"
#    And I fill in "registration_user_xing" with "xingID"
#    And I fill in "registration_user_googleplus" with "googleaccount"
#    Then I click on "Firmendaten"
#    When I fill in "registration_company_title" with "ikusei GmbH"
#    And I fill in "registration_company_legal_form" with "GmbH"
#    And I fill in "registration_company_location_attributes_street" with "Zossenerstrasse 55"
#    And I fill in "registration_company_location_attributes_city" with "Berlin"
#    And I fill in "registration_company_location_attributes_zip" with "10961"
#    And I fill in "registration_company_location_attributes_region" with "Kreuzberg"
#    And I fill in "registration_company_location_attributes_country" with "Deutschland"
#    And I fill in "registration_company_phone" with "03012341234"
#    And I fill in "registration_company_fax" with "03012345697"
#    And I fill in "registration_company_homepage" with "www.ikusei.de"
#    And I fill in "registration_company_sector" with "IT, Web, Design"
#    Then I click on "Accountdaten"
#    When I fill in "registration_user_password" with "geheim1234"
#    And I fill in "registration_user_password_confirmation" with "geheim1234"
#    Then I press "Absenden"
#    And I should see "Ihre Registrierung wurde erfolgreich abgeschlossen! Sie erhalten zusätzliche eine Email" within "#goldencobra_events_event_popup"
#    And I should have a "User" stored with following attributes:
#      | gender | true |
#      | title | "Dr." |
#      | firstname | "Tim" |
#      | lastname | "Test" |
#      | function | "Developer" |
#      | email | "tim.test@tester.de" |
#      | phone | "030755667523" |
#      | fax | "030755667529" |
#      | facebook | "facebook_id" |
#      | twitter | "marcometz" |
#      | linkedin | "myLinkdid" |
#      | xing | "xingID" |
#      | googleplus | "googleaccount" |
#    And I should have a "GoldencobraEvents::Company" stored with following attributes:
#      | title | "ikusei GmbH" |
#      | legal_form | "GmbH" |
#      | phone | "03012341234" |
#      | fax | "03012345697" |
#      | homepage | "www.ikusei.de" |
#      | sector | "IT, Web, Design" |
#    And I should have a "Goldencobra::Location" stored with following attributes:
#      | street | "Zossenerstrasse 55" |
#      | city | "Berlin" |
#      | zip | "10961" |
#      | region | "Kreuzberg" |
#      | country | "Deutschland" |
#    And I should have a "GoldencobraEvents::EventRegistration" stored with following attributes:
#      | event_pricegroup_id | 8 |
#
#
