class CreateGoldencobraEventsCompanies < ActiveRecord::Migration
  def change
    create_table :goldencobra_events_companies do |t|
      t.string :title
      t.string :legal_form
      t.integer :location_id
      t.string :phone
      t.string :fax
      t.string :homepage
      t.string :sector

      t.timestamps
    end
  end
end
