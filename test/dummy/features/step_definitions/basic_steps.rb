Given /^that I am not logged in$/ do
  visit "/admin/logout"
end

When /^I click on "([^\"]*)"$/ do |arg1|
  find_link(arg1).click
end

When /^I visit url "([^\"]*)"$/ do |arg1|
  visit(arg1)
end

When /^I click "([^\"]*)"$/ do |arg1|
  find(arg1).click
end

When /^I press "([^\"]*)"$/ do |arg1|
  find_button(arg1).click
end

When /^I fill in "([^"]*)" with "([^"]*)"$/ do |arg1, arg2|
  fill_in(arg1, :with => arg2)
end

Then /^I fill in "([^"]*)" with "([^"]*)" after "([^"]*)" seconds$/ do |arg1, arg2, arg3|
  sleep arg3.to_i
  page.execute_script("$('#{arg1}').attr('value', '#{arg2}')")
end

Then /^I select "([^"]*)" within "([^"]*)"$/ do |arg1, arg2|
  find(arg2).select(arg1)
end

Then /^I fill in "([^"]*)" within "([^"]*)"$/ do |arg1, arg2|
  page.execute_script("$('#{arg2}').attr('value', '#{arg1}')")
end

Then /^I choose "([^"]*)"$/ do |arg1|
  choose(arg1)
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
    create(arg1.singularize.to_sym ,data)
  end
end

Given /^no "([^"]*)" exist$/ do |arg1|
  eval("#{arg1}.destroy_all")
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

Then %r{^I should see "([^"]*)" inside ([^"].*)$} do |expected_text, named_element|
  sleep 15
  selector = element_for(named_element)
  within_frame selector do
    page.should have_content(expected_text)
  end
end

Then /^I should see "([^"]*)" within textfield "([^"]*)"$/ do |arg1, arg2|
  page.find_field("#{arg2}").value.should == "#{arg1}"
end

Then /^I remove jquery chosen$/ do
  page.execute_script("$('select').removeClass('chzn-done').css('display', 'inline').data('chosen', null);")
  page.execute_script("$('.chzn-container').remove();")
end

Then /^the count of elements "(.*?)" should be "(.*?)"$/ do |arg1, arg2|
  page.has_css?(arg1, :count => arg2)
end

When /^I wait for (\d+) seconds$/ do |arg1|
  sleep arg1.to_i
end