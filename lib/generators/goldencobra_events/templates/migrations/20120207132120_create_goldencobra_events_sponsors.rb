class CreateGoldencobraEventsSponsors < ActiveRecord::Migration
  def change
    create_table :goldencobra_events_sponsors do |t|
      t.string :title
      t.string :description
      t.string :link_url
      t.string :size_of_sponsorship
      t.string :type_of_sponsorship

      t.timestamps
    end
  end
end
