class CreateGoldencobraEventsEventSponsors < ActiveRecord::Migration
  def change
    create_table :goldencobra_events_event_sponsors do |t|
      t.integer :event_id
      t.integer :sponsor_id

      t.timestamps
    end
  end
end
