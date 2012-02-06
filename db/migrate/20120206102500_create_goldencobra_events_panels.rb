class CreateGoldencobraEventsPanels < ActiveRecord::Migration
  def change
    create_table :goldencobra_events_panels do |t|
      t.string :title
      t.string :description
      t.string :link_url

      t.timestamps
    end
  end
end
