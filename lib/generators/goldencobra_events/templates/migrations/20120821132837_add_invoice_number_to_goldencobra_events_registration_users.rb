class AddInvoiceNumberToGoldencobraEventsRegistrationUsers < ActiveRecord::Migration
  def change
    add_column :goldencobra_events_registration_users, :invoice_number, :string
  end
end
