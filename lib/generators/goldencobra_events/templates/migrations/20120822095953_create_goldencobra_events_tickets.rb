class CreateGoldencobraEventsTickets < ActiveRecord::Migration
  def change
    create_table :goldencobra_events_tickets do |t|
      t.integer :event_registration_id

      t.timestamps
    end
  end
end
