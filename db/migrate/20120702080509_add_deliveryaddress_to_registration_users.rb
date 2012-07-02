class AddDeliveryaddressToRegistrationUsers < ActiveRecord::Migration
  def change
    add_column :goldencobra_events_registration_users, :delivery_gender, :boolean
    add_column :goldencobra_events_registration_users, :delivery_title, :string
    add_column :goldencobra_events_registration_users, :delivery_firstname, :string
    add_column :goldencobra_events_registration_users, :delivery_lastname, :string
    add_column :goldencobra_events_registration_users, :delivery_function, :string
    add_column :goldencobra_events_registration_users, :delivery_phone, :string
    add_column :goldencobra_events_registration_users, :delivery_company_id, :integer
    add_column :goldencobra_events_registration_users, :delivery_contact_person, :string
    add_column :goldencobra_events_registration_users, :delivery_department, :string
  end
end
