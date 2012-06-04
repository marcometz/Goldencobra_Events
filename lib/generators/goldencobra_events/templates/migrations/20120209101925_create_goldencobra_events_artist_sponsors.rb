class CreateGoldencobraEventsArtistSponsors < ActiveRecord::Migration
  def change
    create_table :goldencobra_events_artist_sponsors do |t|
      t.integer :artist_id
      t.integer :sponsor_id

      t.timestamps
    end
  end
end
