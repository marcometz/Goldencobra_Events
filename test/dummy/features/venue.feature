Feature: Create and manage venues
  In order to make an venue
  As an admin
  I want to create and manage some locations

Scenario: Go to the venues admin site
  Given that a confirmed admin exists
  And I am logged in as "admin@test.de" with password "secure12"
  When I go to the admin list of venues
  Then I should see "Venues"
  When I click on "New Venue" within ".action_items"
  Then I should see "New Venue" within "h2#page_title"
  And I fill in "venue_title" with "ikusei GmbH"
  And I fill in "venue_description" with "wir machen alles"
  And I fill in "venue_location_street" with "Zossener Str."
  And I fill in "venue_location_city" with "Berlin"
  And I fill in "venue_location_zip" with "10961"
  And I fill in "venue_location_region" with "Kreuzberg"
  And I fill in "venue_location_country" with "Deutschland"
  Then I press "Create Venue"
  And I should see "ikusei GmbH"
  And I should see "wir machen alles"
  And I should see "Zossener Str."  
  And I should see "Berlin"
  And I should see "10961"
  And I should see "Kreuzberg"
  And I should see "Deutschland"      
