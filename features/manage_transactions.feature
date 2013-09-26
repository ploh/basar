Feature: Enter transaction
  In order to sell stuff
  a check-out person
  wants to enter a transaction with all its items

Scenario: Register new transaction
  Given I am on the new transaction page
  And I press "Save"
  Then I should see "Transaction (...) created"
