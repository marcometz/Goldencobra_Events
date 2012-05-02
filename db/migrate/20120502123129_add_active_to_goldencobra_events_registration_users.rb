class AddActiveToGoldencobraEventsRegistrationUsers < ActiveRecord::Migration
  def change
    add_column :goldencobra_events_registration_users, :active, :boolean, :default => true
  end
end
