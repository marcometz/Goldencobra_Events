class AddPanelToGoldencobraEventsEvents < ActiveRecord::Migration
  def change
    add_column :goldencobra_events_events, :panel_id, :integer

  end
end
