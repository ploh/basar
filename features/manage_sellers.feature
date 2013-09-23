Feature: Manage sellers
  In order to [goal]
  [stakeholder]
  wants [behaviour]

Scenario: Register new seller
  Given I am on the new seller page
  When I fill in "Name" with "name 1"
  And I fill in "Number" with "1"
  And I fill in "Initials" with "initials 1"
  And I fill in "Rate" with "rate 1"
  And I press "Create"
  Then I should see "name 1"
  And I should see "1"
  And I should see "initials 1"
  And I should see "rate 1"

Scenario: Delete seller
  Given the following sellers:
    |name|number|initials|rate|
    |name 1|1|initials 1|rate 1|
    |name 2|2|initials 2|rate 2|
    |name 3|3|initials 3|rate 3|
    |name 4|4|initials 4|rate 4|
  When I delete the 3rd seller
  Then I should see the following sellers:
    |Name|Number|Initials|Rate|
    |name 1|1|initials 1|rate 1|
    |name 2|2|initials 2|rate 2|
    |name 4|4|initials 4|rate 4|
