Given /^that a confirmed admin exists$/ do
  @user = create(:admin_user)
  @admin_role = create(:admin_role)
  @permission = create(:admin_permission)
  @permission.role = @admin_role
  @permission.save
  @user.roles << @admin_role
end


Given /^that a confirmed guest exists$/ do
  @user = create(:guest_user)
  @user.roles << create(:guest_role)
end

Given /^I am logged in as "([^\"]*)" with password "([^\"]*)"$/ do |email, password|
  visit "/admin/logout"
  visit "/admin/login"
  fill_in "user[email]", :with => email
  fill_in "user[password]", :with => password
  click_button "Login"
  page.should have_content('Signed in successfully.')
end
