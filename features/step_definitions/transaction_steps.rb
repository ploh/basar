Given /^the following transactions:$/ do |transactions|
  Transaction.create!(transactions.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) transaction$/ do |pos|
  visit transactions_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following transactions:$/ do |expected_transactions_table|
  expected_transactions_table.diff!(tableish('table tr', 'td,th'))
end
