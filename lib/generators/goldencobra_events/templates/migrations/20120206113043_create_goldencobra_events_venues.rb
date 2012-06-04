class CreateGoldencobraEventsVenues < ActiveRecord::Migration
  def change
    create_table :goldencobra_events_venues do |t|
      t.integer :location_id
      t.string :title
      t.text :description
      t.string :link_url
      t.string :phone
      t.string :email

      t.timestamps
    end
  end
end
