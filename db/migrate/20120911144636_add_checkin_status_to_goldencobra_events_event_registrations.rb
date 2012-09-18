class AddCheckinStatusToGoldencobraEventsEventRegistrations < ActiveRecord::Migration
  def change
    add_column :goldencobra_events_event_registrations, :checkin_status, :string
  end
end
