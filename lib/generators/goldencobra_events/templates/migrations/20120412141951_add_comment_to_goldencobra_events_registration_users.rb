class AddCommentToGoldencobraEventsRegistrationUsers < ActiveRecord::Migration
  def change
    add_column :goldencobra_events_registration_users, :comment, :text
  end
end
