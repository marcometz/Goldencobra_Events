class AddLocationToGoldencobraEventsArtists < ActiveRecord::Migration
  def change
    add_column :goldencobra_events_artists, :location_id, :integer

  end
end
