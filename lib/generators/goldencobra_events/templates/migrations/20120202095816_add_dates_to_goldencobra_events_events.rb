class AddDatesToGoldencobraEventsEvents < ActiveRecord::Migration
  def change
    add_column :goldencobra_events_events, :start_date, :datetime

    add_column :goldencobra_events_events, :end_date, :datetime

  end
end
