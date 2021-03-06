Given /I am within the subdomain "([^"]*)"/ do |subdomain|
  Capybara.default_host = "#{subdomain}.example.com" #for Rack::Test
  Capybara.app_host = "http://#{subdomain}.example.com:9887" if Capybara.current_driver == :selenium
  visit "http://#{subdomain}.example.com" + rooms_path
end

Given /^#{capture_model} has an account named "([^"]*)"$/ do |user, account_name|
  account = Factory(:account, :subdomain => account_name)
  find_model(user).accounts << account
end

Then /^the account "([^"]*)" should belong to me$/ do |subdomain|
  Account.find_by_subdomain(subdomain).users.find_by_id(model("the user").id).should_not be_nil
end

When /^I change to the first account$/ do
  within("ul") do
    find("a:first").click
  end
end
