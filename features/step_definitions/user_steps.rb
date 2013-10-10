Given /^the following (.+) records?$/ do |factory, table|
  table.hashes.each do |hash|
    FactoryGirl.create(factory, hash)
  end
end

Given /^I have valid credentials$/ do
  User.create(username: 'name', email: 'email@email.com', password: 'password', confirmed: true)
end

Given /^I am logged in(?: as )?(\S*)$/ do |username|
  username = username.blank? ? 'name' : username
  email = 'unused@email.com'
  password = 'password'
  admin = username == 'admin' ? true : false
  User.create(
    username: username,
    email: email,
    password: password,
    admin: admin,
    confirmed: true
  )
  visit login_path
  fill_in 'session_form_email', with: email
  fill_in 'session_form_password', with: password
  click_button 'Login'
end

Then /^I should be logged in$/ do
  find('#flash_messages').find('div').should have_content 'logged in'
end

Then /^I should be logged out$/ do
  find('#flash_messages').find('div').should have_content 'logged out'
  find_link('Login').visible?.should be_true
end

Then /^the (.*) should be (.*)$/ do |model, action|
  find('#flash_messages').find('div').should have_content "#{model} #{action}."
end

