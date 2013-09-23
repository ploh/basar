Given /^the following sellers:$/ do |sellers|
  Seller.create!(sellers.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) seller$/ do |pos|
  visit sellers_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following sellers:$/ do |expected_sellers_table|
  expected_sellers_table.diff!(tableish('table tr', 'td,th'))
end
