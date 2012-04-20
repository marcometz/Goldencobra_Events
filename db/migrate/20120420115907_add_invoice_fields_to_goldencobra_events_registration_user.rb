class AddInvoiceFieldsToGoldencobraEventsRegistrationUser < ActiveRecord::Migration
  def change
    add_column :goldencobra_events_registration_users, :invoice_sent, :datetime
    add_column :goldencobra_events_registration_users, :payed_on, :datetime
    add_column :goldencobra_events_registration_users, :first_reminder_sent, :datetime
    add_column :goldencobra_events_registration_users, :second_reminder_sent, :datetime
  end
end
