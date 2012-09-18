class CreateGoldencobraEventsEventPricegroups < ActiveRecord::Migration
  def change
    create_table :goldencobra_events_event_pricegroups do |t|
      t.integer :event_id
      t.integer :pricegroup_id
      t.float :price, :default => 0.0
      t.integer :max_number_of_participators, :default => 0
      t.datetime :cancelation_until
      t.datetime :start_reservation
      t.datetime :end_reservation
      t.boolean :available, :default => false

      t.timestamps
    end
  end
end
