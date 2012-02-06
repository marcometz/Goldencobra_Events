# This migration comes from goldencobra_events (originally 20120201112815)
class AddActiveToGoldencograEventsEvents < ActiveRecord::Migration
  def change
    add_column :goldencobra_events_events, :active, :boolean, :default => true
    add_column :goldencobra_events_events, :external_link, :string
    add_column :goldencobra_events_events, :max_number_of_participators, :integer, :default => 0
    add_column :goldencobra_events_events, :type_of_event, :string
    add_column :goldencobra_events_events, :type_of_registration, :string
    add_column :goldencobra_events_events, :exclusive, :boolean, :default => false
  end
end
