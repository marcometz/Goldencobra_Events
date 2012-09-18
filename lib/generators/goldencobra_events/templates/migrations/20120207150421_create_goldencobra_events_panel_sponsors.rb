class CreateGoldencobraEventsPanelSponsors < ActiveRecord::Migration
  def change
    create_table :goldencobra_events_panel_sponsors do |t|
      t.integer :panel_id
      t.integer :sponsor_id

      t.timestamps
    end
  end
end
