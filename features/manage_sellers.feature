Feature: Manage sellers
  In order to see and change who is participating in the basar
  the basar organizer
  wants to view, create, edit and delete sellers

Scenario: Register new seller
  Given I am a new, authenticated admin
  And I am on the new seller page
  When I fill in "Name" with "Inge Schmidt"
  And I fill in "Number" with "01"
  And I fill in "Initials" with "SCM"
  And I fill in "Rate" with "20"
  And I press "Save"
  Then I should see "Inge Schmidt"
  And I should see "1"
  And I should see "SCM"
  And I should see "20 %"
