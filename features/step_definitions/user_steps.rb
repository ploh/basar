Given /^I am not authenticated$/ do
  visit '/users/sign_out'
end

Given /^I am a new, authenticated (\w+)$/ do |role|
  email = "test#{rand(100000000)}@test.host"
  password = "secretpass"
  User.create! email: email, password: password, role: role, confirmed_at: Time.now

  visit '/users/sign_in'
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password
  click_button "Log in"
end
