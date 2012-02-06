class AddVenueToGoldencobraEventsEvents < ActiveRecord::Migration
  def change
    add_column :goldencobra_events_events, :venue_id, :integer

  end
end
