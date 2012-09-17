class CreateGoldencobraEventsSponsorImages < ActiveRecord::Migration
  def change
    create_table :goldencobra_events_sponsor_images do |t|
      t.integer :sponsor_id
      t.integer :image_id

      t.timestamps
    end
  end
end
