Then /^"([^\"]*)" should be filled in with "([^\"]*)"$/ do |field, value|
  page.find_field(field).value.should eq value
end

Then /^The selected tab should be "([^\"]*)"$/ do |tab|
  page.find("##{tab}").has_css?('active')
end
