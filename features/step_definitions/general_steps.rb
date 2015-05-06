When /^(?:|I )am in (?:a|the) (\d+)(?:st|nd|rd|th) browser window$/ do |number|
  Capybara.session_name = number.to_i.to_s
end

Given /^PENDING/ do
  pending
end

When /^(?:|I )wait (?:for )?(\d+(?:\.\d+)?) seconds?$/ do |seconds|
  sleep seconds.to_f
end

Then /^debug$/ do
  byebug
end

Then /^prompt$/ do
  print "Press ENTER to continue!"
  STDIN.gets
end
