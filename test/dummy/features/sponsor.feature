Feature: Create and manage sponsors
  In order to make a sponsor
  As an admin
  I want to create and manage some sponsors
  Background:
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    And the following uploads exist:
      | image_file_name | source  | rights |
      | "Bild1"         | "ikusei" | "alle" |
      | "Bild2"         | "ikuse2" | "alle" |
    And the following sponsors exist:
      | title              | description | id |
      | "Audi Deutschland" | "Autos"     |  1 |
      | "Dr. Oetker"       | "Speisen"   |  2 |
    And the following events exist:
      | title                        | parent_id | id | active | sponsor_ids |
      | "Event1"                     |           |  1 | true   |           1 |
      | "Event2"                     | 1         |  2 | true   |           1 |
      | "Event3"                     | 1         |  3 | true   |           2 |
      | "Event4"                     | 2         |  4 | true   |             |
    And the following panels exist:
      | title                       | id | sponsor_ids |
      | "Naturstrom Panel"          |  1 |         1,2 |
      | "Gesund ernaehren Panel"     |  2 |             |

  @javascript
  Scenario: Go to the sponsor admin site and create a new sponsor
    When I go to the admin list of sponsors
    Then I should see "Sponsors"
    When I click on "New Sponsor" within ".action_items"
    Then I should see "New Sponsor" within "h2#page_title"
    And I fill in "sponsor_title" with "Audi Deutschland GmbH"
    And I fill in "sponsor_description" with "Starke Fahrzeuge" after "5" seconds
    And I fill in "sponsor_link_url" with "http://www.audi.de"
    And I fill in "sponsor_email" with "info@audi.de"
    And I fill in "sponsor_telephone" with "030 456 77 88"
    And I fill in "sponsor_location_attributes_street" with "Zossener Str."
    And I fill in "sponsor_location_attributes_city" with "Berlin"
    And I fill in "sponsor_location_attributes_zip" with "10961"
    And I fill in "sponsor_location_attributes_region" with "Kreuzberg"
    And I fill in "sponsor_location_attributes_country" with "Deutschland"
    And I select "Bild2" within ".sponsor_logo_image_file"
    And I click on "Add New Sponsor Image"
    And I select "Bild1" within ".sponsor_image_file"
    And I press "Create Sponsor"
    Then I should see "Audi Deutschland GmbH" within "#main_content"
    # And I should see "Starke Fahrzeuge" within "#main_content"
    And I should see "http://www.audi.de" within "#main_content"
    And I should see "info@audi.de"
    And I should see "030 456 77 88"
    And I should see "Zossener Str."
    And I should see "Berlin"
    And I should see "10961"
    And I should see "Kreuzberg"
    And I should see "Deutschland"
    When I click on "Edit Sponsor"
    Then I should see "Bild1"
    And I should see "Bild2"

  Scenario: Visit a sponsor and look for events and panels
    When I go to the admin list of sponsors
    And I click on "View" within "tr#sponsor_1"
    Then I should see "Event1"
    And I should see "Event2"
    And I should not see "Event3"
    And I should see "Naturstrom Panel"
