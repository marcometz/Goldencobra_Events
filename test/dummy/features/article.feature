Feature: Display event informations on article page
  In order to view event informations
  I go to the article page

  Scenario: Visit new Article in frontend and see event informations
    Given that I am not logged in
    And the following "articles" exist:
      | title               | url_name          | teaser         | content                   | id | event_id | active |
      | "Dies ist ein Test" | dies-ist-ein-test | "Die kleine …" | "Die kleine Maus wandert. |  1 |        1 | true   |
    And the following "pricegroups" exist:
      | title       | id |
      | "Studenten" |  1 |
    And the following "events" exist:
      | title    | description             | id | parent_id | external_link          | max_number_of_participators | type_of_event         | type_of_registration       | exclusive | start_date          | end_date            |
      | "Event1" | "Ein ganz toller Event" | 1  |           | http://www.google.de |                          25 | "Registration needed" | "No cancellation required" |      true | 2012-01-01 11:00:00 | 2012-02-02 10:00:00 |
    And the following "event_pricegroups" exist:
      | event_id | pricegroup_id | price | max_number_of_participators | available | start_reservation     | cancelation_until     | end_reservation       |
      |        1 |             1 |  50.0 |                         500 |      true | "2012-02-01 12:00:00" | "2012-04-01 12:00:00" | "2012-03-01 12:00:00" |
    Then I go to the article page "dies-ist-ein-test"
     And I should see "Dies ist ein Test" within "h1"
     And I should see "Die kleine Maus wandert." within "#article_content"
     And I should see "Event1" within "div.article_event_content .title"
     And I should see "Ein ganz toller Event" within "div.article_event_content .description"
     And I should see "http://www.google.de" within "div.article_event_content .external_link"
     And I should see "25" within "div.article_event_content .max_number_of_participators"
     And I should see "Registration needed" within "div.article_event_content .type_of_event"
     And I should see "No cancellation required" within "div.article_event_content .type_of_registration"
     And I should see "true" within "div.article_event_content .exclusive"
     And I should see "2012-01-01 11:00:00" within "div.article_event_content .start_date"
     And I should see "2012-02-02 10:00:00" within "div.article_event_content .end_date"
     And I should see "1" within ".pricegroup_id"
     And I should see "Studenten" within "li.pricegroup_item .title"
     And I should see "50.0" within ".price"
     And I should see "500" within "li.pricegroup_item .max_number_of_participators"
     And I should see "2012-02-01 12:00:00" within ".start_reservation"
     And I should see "2012-04-01 12:00:00" within ".cancelation_until"
     And I should see "2012-03-01 12:00:00" within ".end_reservation"
