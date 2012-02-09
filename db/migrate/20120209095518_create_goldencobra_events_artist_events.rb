class CreateGoldencobraEventsArtistEvents < ActiveRecord::Migration
  def change
    create_table :goldencobra_events_artist_events do |t|
      t.integer :artist_id
      t.integer :event_id

      t.timestamps
    end
  end
end
