Given /^the following (.+) records?$/ do |factory, table|
  table.hashes.each do |hash|
    FactoryGirl.create(factory, hash)
  end
end

Given /^I have valid credentials$/ do
  User.create(email: 'zanewoodfin@gmail.com', password: 'password')
end

Given /^I am logged in$/ do
  User.create(email: 'zanewoodfin@gmail.com', password: 'password')
  visit login_path
  fill_in 'session_email', with: 'zanewoodfin@gmail.com'
  fill_in 'session_password', with: 'password'
  click_button 'Login'
end

Then /^I should be logged in$/ do
  find('#flash').find('div').should have_content 'logged in'
end

Then /^I should be logged out$/ do
  find('#flash').find('div').should have_content 'logged out'
  find_link('Login').visible?.should be_true
end

Then /^the (.*) should be (.*)$/ do |model, action|
  find('#flash').find('div').should have_content "#{model} #{action}."
end
