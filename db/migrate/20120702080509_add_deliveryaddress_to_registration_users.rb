class AddDeliveryaddressToRegistrationUsers < ActiveRecord::Migration
  def change
    add_column :goldencobra_events_registration_users, :billing_gender, :boolean
    add_column :goldencobra_events_registration_users, :billing_title, :string
    add_column :goldencobra_events_registration_users, :billing_firstname, :string
    add_column :goldencobra_events_registration_users, :billing_lastname, :string
    add_column :goldencobra_events_registration_users, :billing_function, :string
    add_column :goldencobra_events_registration_users, :billing_phone, :string
    add_column :goldencobra_events_registration_users, :billing_company_id, :integer
    add_column :goldencobra_events_registration_users, :billing_contact_person, :string
    add_column :goldencobra_events_registration_users, :billing_department, :string
  end
end
