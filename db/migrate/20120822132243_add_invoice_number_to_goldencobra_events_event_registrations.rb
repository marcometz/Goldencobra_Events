class AddInvoiceNumberToGoldencobraEventsEventRegistrations < ActiveRecord::Migration
  def change
    add_column :goldencobra_events_event_registrations, :invoice_number, :string
  end
end
