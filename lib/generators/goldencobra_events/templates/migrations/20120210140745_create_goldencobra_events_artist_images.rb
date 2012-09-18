class CreateGoldencobraEventsArtistImages < ActiveRecord::Migration
  def change
    create_table :goldencobra_events_artist_images do |t|
      t.integer :image_id
      t.integer :artist_id

      t.timestamps
    end
  end
end
