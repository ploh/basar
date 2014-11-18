When /^(?:|I )am in (?:a|the) (\d+)(?:st|nd|rd|th) browser window$/ do |number|
  Capybara.session_name = number
end

Given /^PENDING/ do
  pending
end
