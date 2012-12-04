class AddCheckinCountToGoldencobraEventsEventRegistrations < ActiveRecord::Migration
  def change
    add_column :goldencobra_events_event_registrations, :checkin_count, :integer, default: 0
  end
end
