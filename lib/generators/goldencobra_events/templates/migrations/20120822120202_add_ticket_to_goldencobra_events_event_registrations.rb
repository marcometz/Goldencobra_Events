class AddTicketToGoldencobraEventsEventRegistrations < ActiveRecord::Migration
  def change
    add_column :goldencobra_events_event_registrations, :ticket_number, :string
  end
end
