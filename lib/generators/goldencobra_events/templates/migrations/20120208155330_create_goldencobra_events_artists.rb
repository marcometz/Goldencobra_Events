class CreateGoldencobraEventsArtists < ActiveRecord::Migration
  def change
    create_table :goldencobra_events_artists do |t|
      t.string :title
      t.string :description
      t.string :url_link

      t.timestamps
    end
  end
end
