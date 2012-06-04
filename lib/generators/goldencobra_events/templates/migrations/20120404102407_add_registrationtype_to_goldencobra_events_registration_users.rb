class AddRegistrationtypeToGoldencobraEventsRegistrationUsers < ActiveRecord::Migration
  def change
    add_column :goldencobra_events_registration_users, :type_of_registration, :string, :default => "Webseite"
  end
end
