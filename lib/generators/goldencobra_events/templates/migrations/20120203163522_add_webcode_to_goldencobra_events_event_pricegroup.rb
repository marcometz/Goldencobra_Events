class AddWebcodeToGoldencobraEventsEventPricegroup < ActiveRecord::Migration
  def change
    add_column :goldencobra_events_event_pricegroups, :webcode, :string

  end
end
