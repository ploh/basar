Feature: Enter transaction
  In order to sell stuff
  a check-out person
  wants to enter a transaction with all its items


Background:
  Given the following sellers:
    |name|number|initials|rate_in_percent|
    |Inge Schmidt|1     |SCM     |20 |
    |Anna Lohmann|2     |AL      |10 |
    |Astrid Meyer|3     |AM      |15|


@javascript
Scenario: Enter new transaction
  Given I am on the new transaction page
  When I fill in the 1st "Seller" with "SCM01"
  And fill in the 1st "Price" with "3,20"
  And fill in the 2nd "Seller" with "02"
  And fill in the 2nd "Price" with ".4"
  And press Enter
  Then I should be on a transaction's page
  And should see "Transaction (...) created"


@javascript
Scenario: Input erroneous transaction
  Given I am on the new transaction page
  When I fill in the 1st "Seller" with "SCM02"
  And press Tab
  Then I should see an error mark on the 1st "Seller"


@javascript
Scenario: Press enter on erroneous transaction
  Given I am on the new transaction page
  When I fill in the 1st "Seller" with "SCM02"
  And press Enter
  Then I should see an error mark on the 1st "Seller"
  And I should see "Items seller code does not exist, maybe you meant one of SCM01, AL02"


@javascript
Scenario: Add seller during transaction input
  When I am in the 1st browser window
  And I am on the new transaction page
  And I fill in the 1st "Seller" with "SCM01"
  And fill in the 1st "Price" with "3,20"
  And press Tab
  Then I should not see an error mark on the 1st "Seller"

  When I am in a 2nd browser window
  And I am on the new seller page
  And I fill in "Name" with "Petra Meyer"
  And I fill in "Number" with "04"
  And I fill in "Initials" with "PM"
  And I fill in "Rate" with "15"
  And press Enter
  Then I should be on the sellers page
  And should see "Seller (...) created"

  When I am in the 1st browser window
  And I fill in the 2nd "Seller" with "PM04"
  And press Tab
  Then PENDING I should not see an error mark on the 2nd "Seller"
