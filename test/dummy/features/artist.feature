Feature: Create and manage artists
  In order to make an artist
  As an admin
  I want to create and manage some artists

  Background:
    Given that a confirmed admin exists
    And I am logged in as "admin@test.de" with password "secure12"
    And the following uploads exist:
      | image_file_name | source  | rights |
      | "Bild1"         | "ikusei" | "alle" |
      | "Bild2"         | "ikuse2" | "alle" |
    And the following "sponsors" exist:
      | title              | description | id |
      | "Audi Deutschland" | "Autos"     |  1 |
      | "Dr. Oetker"       | "Speisen"   |  2 |
    And the following artists exist:
      | title             | description | id |
      | "Bodo Wartke"     | "toll toll" |  1 |

  @javascript
  Scenario: Go to the artist sponsor site and create a new artist
    When I go to the admin list of artists
    Then I should see "Artists"
    When I click on "New Artist" within ".action_items"
    Then I should see "New Artist" within "h2#page_title"
    And I fill in "artist_title" with "Bodo Wartke"
    And I fill in "artist_description" with "Ein ganz ein wundervoller Kuenstler"
    And I fill in "artist_url_link" with "http://www.bodowartke.de"
    And I click on "Add New Artist Image"
    And I select "Bild1" within ".artist_image_file"
    And I press "Create Artist"
    Then I should see "Bodo Wartke" within "#main_content"
    # And I should see "Ein ganz ein wundervoller Kuenstler" within "#main_content"
    And I should see "http://www.bodowartke.de" within "#main_content"
    When I click on "Edit Artist"
    Then I should see "Bild1"
    
  @javascript
  Scenario: Set sponsors for an artist
    When I go to the admin list of artists
    Then I click on "Edit" within "tr#artist_1"
    And I remove jquery chosen
    And I select "Audi Deutschland" within "#artist_sponsors_input"
    And I select "Dr. Oetker" within "#event_sponsors_input"
    Then I press "Update Artist"
    And I should see "Audi Deutschland"
    And I should see "Dr. Oetker"


