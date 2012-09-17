class AddDescriptionToGoldencobraEventsEventPricegroups < ActiveRecord::Migration
  def change
    add_column :goldencobra_events_event_pricegroups, :description, :text
  end
end
