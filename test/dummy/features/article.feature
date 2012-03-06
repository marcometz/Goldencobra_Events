Feature: Display event informations on article page
  In order to view event informations
  I go to the article page
  
  Background:
    Given that I am not logged in
    And the following "articles" exist:
      | title               | url_name          | teaser         | content                    | id | event_id | active | eventmoduletype |
      | "Dies ist ein Test" | dies-ist-ein-test | "Die kleine …" | "Die kleine Maus wandert." |  1 |        1 | true   | program         |
    And the following "pricegroups" exist:
      | title       | id |
      | "Studenten" |  1 |
    And the following "uploads" exist:
      | id | image_file_name     |
      |  1 |          Bild_1.jpg |
      |  2 |          Bild_2.jpg |
      |  3 |          Bild_3.jpg |
      |  4 |          Bild_4.jpg |
      |  5 |          Bild_5.jpg |
      |  6 |          Bild_6.jpg |
    And the following "events" exist:
      | title    | description             | id | parent_id | external_link        | max_number_of_participators | type_of_event         | type_of_registration       | exclusive | start_date          | end_date            | venue_id | teaser_image_id |
      | Event1   | "Ein ganz toller Event" | 1  |           | http://www.google.de |                          25 | "Registration needed" | "No cancellation required" |      true | 2012-01-01 11:00:00 | 2012-02-02 10:00:00 |        1 |               6 |
    And the following "event_pricegroups" exist:
      | event_id | pricegroup_id | price | max_number_of_participators | available | start_reservation     | cancelation_until     | end_reservation       |
      |        1 |             1 |  50.0 |                         500 |      true | "2012-02-01 12:00:00" | "2012-04-01 12:00:00" | "2012-03-01 12:00:00" |
    And the following "locations" exist:
      | street         |  city  |  zip  |  region  |  country  |  id |
      | Grunerstr. 1   | Berlin | 12345 | "Berlin" | "Germany" |   1 |
      | Kudamm 1       | Berlin | 12345 | "Berlin" | "Germany" |   2 |
      | Gneisenau 24   | Berlin | 12345 | "Berlin" | "Germany" |   3 |
    And the following "venues" exist:
      | title            |  description                            | link_url                     | phone            |  email                  |  id | location_id |
      | "Kongresshalle" | "Ein Kongresszentrum am Alexanderplatz" | http://www.kongresshalle.de  | (030) 123 456 77 | "info@kongresshalle.de" |   1 |        1    |
    And the following "sponsors" exist:
      | title              | description | id | location_id | logo_id |
      | "Audi Deutschland" | "Autos"     |  1 |           2 |       5 |
      | "Dr. Oetker"       | "Speisen"   |  2 |           3 |         |
    And the following "sponsor_images" exist:
      | id | sponsor_id | image_id |
      |  1 |          1 |        3 |
      |  2 |          1 |        4 |
    And the following "event_sponsors" exist:
      | id | event_id | sponsor_id |
      |  1 |        1 |          1 |
      |  2 |        1 |          2 |
    And the following "artists" exist:
      | title             | description | id |
      | "Bodo Wartke"     | "toll toll" |  1 |
    And the following "artist_events" exist:
      | id | artist_id | event_id |
      |  1 |         1 |        1 |
    And the following "artist_images" exist:
      | id | artist_id | image_id |
      |  1 |         1 |        1 |
      |  2 |         1 |        2 |

  Scenario: Visit new Article in frontend and see event informations
    When I go to the article page "dies-ist-ein-test"
     Then I should see "Dies ist ein Test" within "h1"
     And I should see "Die kleine Maus wandert." within "#article_content"
     # Event
     And I should see "Event1" within "div.article_event_content .title"
     And I should see "Ein ganz toller Event" within "div.article_event_content .description"
     And I should see "http://www.google.de" within "div.article_event_content .external_link"
     And I should see "25" within "div.article_event_content .number_of_participators_label"
     And I should see "Registration needed" within "div.article_event_content .type_of_event"
     And I should see "No cancellation required" within "div.article_event_content .type_of_registration"
     And I should see "true" within "div.article_event_content .exclusive"
     And I should see "2012-01-01 11:00:00" within "div.article_event_content .start_date"
     And I should see "2012-02-02 10:00:00" within "div.article_event_content .end_date"
     And I should see the image "Bild_6.jpg" with id "6"
     # Pricegroup
     And I should see "1" within "li.pricegroup_item_1 .pricegroup_id"
     And I should see "Studenten" within "li.pricegroup_item_1 .title"
     And I should see "50.0" within "li.pricegroup_item_1 .price"
     And I should see "500" within "li.pricegroup_item_1 .number_of_participators_label"
     And I should see "2012-02-01 12:00:00" within "li.pricegroup_item_1 .start_reservation"
     And I should see "2012-04-01 12:00:00" within "li.pricegroup_item_1 .cancelation_until"
     And I should see "2012-03-01 12:00:00" within "li.pricegroup_item_1 .end_reservation"
     # Location & Venue
     And I should see "Kongresshalle" within "div.venue"
     And I should see "Ein Kongresszentrum am Alexanderplatz" within "div.venue"
     And I should see "Grunerstr. 1, 12345, Berlin" within "div.venue"
     And I should see "http://www.kongresshalle.de" within "div.venue"
     And I should see "(030) 123 456 77" within "div.venue"
     And I should see "info@kongresshalle.de" within "div.venue"
     # Sponsors
     And I should see "Audi Deutschland" within "li.sponsor_item_1 .title"
     And I should see "Kudamm 1, 12345, Berlin" within "li.sponsor_item_1 .complete_location"
     And I should see "Dr. Oetker" within "li.sponsor_item_2 .title"
     And I should see "Gneisenau 24, 12345, Berlin" within "li.sponsor_item_2 .complete_location"
     And I should see the image "Bild_3.jpg" with id "3"
     And I should see the image "Bild_4.jpg" with id "4"
     And I should see the image "Bild_5.jpg" with id "5"
     # Artists
     And I should see "Bodo Wartke" within "li.artist_item_1 .title"
     And I should see "toll toll" within "li.artist_item_1 .description"
     And I should see the image "Bild_1.jpg" with id "1"
     And I should see the image "Bild_2.jpg" with id "2"
