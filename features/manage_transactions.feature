Feature: Enter transaction
  In order to sell stuff
  a check-out person
  wants to enter a transaction with all its items

@javascript
Scenario: Enter new transaction
  Given the following sellers:
    |name|number|initials|rate_in_percent|
    |Inge Schmidt|1     |SCM     |20 |
    |Anna Lohmann|2     |AL      |10 |
    |Astrid Meyer|3     |AM      |15|
  And I am on the new transaction page
  When I fill in the 1st "Seller" with "SCM01"
  And I fill in the 1st "Price" with "3,20"
  And I wait for 1 second
  And I fill in the 1st "Price" with "3,20"
  And I press Enter
  And prompt
  Then I should see "Transaction (...) created"
