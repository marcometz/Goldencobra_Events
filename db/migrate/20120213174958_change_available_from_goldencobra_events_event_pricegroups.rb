class ChangeAvailableFromGoldencobraEventsEventPricegroups < ActiveRecord::Migration
  def up
    change_table :goldencobra_events_event_pricegroups do |t|
      t.change :available, :boolean, :default => true
    end
  end

  def down
    change_table :goldencobra_events_event_pricegroups do |t|
      t.change :available, :boolean, :default => false
    end
  end
end
