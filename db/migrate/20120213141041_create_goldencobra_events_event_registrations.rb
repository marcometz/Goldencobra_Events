class CreateGoldencobraEventsEventRegistrations < ActiveRecord::Migration
  def change
    create_table :goldencobra_events_event_registrations do |t|
      t.integer :user_id
      t.integer :event_pricegroup_id
      t.boolean :canceled, :default => false
      t.datetime :canceled_at

      t.timestamps
    end
  end
end
