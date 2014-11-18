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
