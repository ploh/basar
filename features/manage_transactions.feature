Feature: Enter transaction
  In order to sell stuff
  a check-out person
  wants to enter a transaction with all its items

Scenario: Register new transaction
  Given the following sellers:
    |name|number|initials|rate_in_percent|
    |Inge Schmidt|1     |SCM     |20 |
    |Anna Lohmann|2     |AL      |10 |
    |Astrid Meyer|3     |AM      |15|
  And I am on the new transaction page
  When I fill in "Seller 1" with "SCM20"
  And I fill in "Price 1" with "3,20"
  And I press "Save"
  Then I should be on the transactions page
  And I should see "Transaction (...) created"
