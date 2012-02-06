# This migration comes from goldencobra_events (originally 20120131165313)
class CreateGoldencobraEventsEvents < ActiveRecord::Migration
  def change
    create_table :goldencobra_events_events do |t|
      t.string :ancestry
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
