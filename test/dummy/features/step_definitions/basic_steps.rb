Given /^that I am not logged in$/ do
  visit "/admin/logout"
end

When /^I click on "([^\"]*)"$/ do |arg1|
  find_link(arg1).click
end

When /^I visit url "([^\"]*)"$/ do |arg1|
  visit(arg1)
end


When /^I press "([^\"]*)"$/ do |arg1|
  find_button(arg1).click
end

When /^I fill in "([^"]*)" with "([^"]*)"$/ do |arg1, arg2|
  fill_in(arg1, :with => arg2)
end

Then /^I select "([^"]*)" within "([^"]*)"$/ do |arg1, arg2|
  find(arg2).select(arg1)
end


Then /^I fill in "([^"]*)" within "([^"]*)"$/ do |arg1, arg2|
  page.execute_script("$('#{arg2}').attr('value', '#{arg1}')")
end


Then /^I should see "([^\"]*)"$/ do |arg1|
  page.should have_content(arg1)
end

Then /the text "([^"]*)"(?: within "([^"]*)")? should be visible/ do |text, nodes| 
  scope = nodes ? nodes : '//*' 
  page.find(:xpath, "#{scope}[contains(text(), '#{text}')]").visible?.should be_true 
end

Then /the text "([^"]*)"(?: within "([^"]*)")? should not be visible/ do |text, nodes| 
  scope = nodes ? nodes : '//*' 
  page.find(:xpath, "#{scope}[contains(text(), '#{text}')]").visible?.should be_false
end


Then /^I should see "([^\"]*)" within "([^\"]*)"$/ do |arg1, content_posistion|
  find(content_posistion).should have_content(arg1)
end


Then /^I should not see "([^\"]*)"$/ do |arg1|
  page.should have_no_content(arg1)
end

Then /^I should not see "([^"]*)" within "([^"]*)"$/ do |arg1, content_posistion|
  find(content_posistion).should have_no_content(arg1)
end


Then /^show me the page$/ do
  save_and_open_page
end

Then /^I click on "([^"]*)" within "([^"]*)"$/ do |arg1, arg2|
  find(arg2).find_link(arg1).click
end

Then /^I check "([^"]*)"$/ do |arg1|
  check(arg1)
end

Then /^I check "([^"]*)" within "([^"]*)"$/ do |arg1, arg2|
  find(arg2).check(arg1)
end

Then /^I choose "([^"]*)" within "([^"]*)"$/ do |arg1, arg2|
  find(arg2).choose(arg1)
end


Given /^the following "([^"]*)" exist:$/ do |arg1, table|
  table.hashes.each do |data|
    Factory(arg1.singularize.to_sym ,data)
  end
end

Then /^I should see the image "(.+)" with id "([^\"]*)"$/ do |image, id|
    page.should have_xpath("//img[@src=\"/system/images/#{id}/thumb/#{image}\"]")
end

Then /^I close the popup_window "([^\"]*)"$/ do |arg1|
  page.execute_script("$('##{arg1}').overlay().close();")
end

Given /^default settings exists$/ do
  Goldencobra::Setting.import_default_settings(GoldencobraEvents::Engine.root + "config/settings.yml")
end

Then /^I should have a "([^"]*)" stored with following attributes:$/ do |arg1, table|
  # table is a Cucumber::Ast::Table
  data = table.raw.map{|a| ":#{a[0]} => #{a[1]}"}.join(', ')
  model_obj = eval("#{arg1}.where(#{data})")
  model_obj.count.should == 1 
end