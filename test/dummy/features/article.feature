Feature: Display event informations on article page
  In order to view event informations
  I go to the article page

  Scenario: Visit new Article in frontend and see event informations
    Given that I am not logged in
    And the following "articles" exist:
      | title               | url_name            | teaser         | content                   | id |
      | "Dies ist ein Test" | dies-ist-ein-test | "Die kleine …" | "Die kleine Maus wandert. |  1 |
    And the following "pricegroups" exist:
      | title       | id |
      | "Studenten" |  1 |
    And the following "events" exist:
      | title    | id | parent_id |
      | "Event1" | 1  |           |
    And the following "event_pricegroups" exist:
      | event_id | pricegroup_id | price | max_number_of_participators | available |
      |        1 |             1 |  50.0 |                         500 |      true |
    Then I go to the article page "dies-ist-ein-test"
     And I should see "Dies ist ein Test" within "h1"
     And I should see "Die kleine Maus wandert." within "#article_content"
     And show me the page
     And I should see "1" within ".pricegroup_id"
