require 'spec_helper'

describe "GoldencobraEvents::RegistrationUser" do
  describe "registration" do
    before(:each) do
      company = GoldencobraEvents::Company.create(title: "ACME Inc.")
      User.create(firstname: "Fooname",
                  lastname: "Barname",
                  email: "foo@bar.com",
                  password: "foobar123",
                  password_confirmation: "foobar123",
                  company_id: company.id, gender: true)
    end

    it "should create a new registration from master data" do
      user_id = User.last.id
      reg_user = GoldencobraEvents::RegistrationUser.create_from_master_data(user_id)
      reg_user.should_not eq(nil)
    end

    it "should be a matching registation" do
      user_id = User.last.id
      reg_user = GoldencobraEvents::RegistrationUser.create_from_master_data(user_id)
      expect(GoldencobraEvents::RegistrationUser.last.email).to eq(reg_user.email)
    end

    it "should match the company" do
      user_id = User.last.id
      reg_user = GoldencobraEvents::RegistrationUser.create_from_master_data(user_id)
      expect(GoldencobraEvents::Company.find(GoldencobraEvents::RegistrationUser.last.company_id)).to eq(GoldencobraEvents::Company.find(User.last.company_id))
    end
  end
end