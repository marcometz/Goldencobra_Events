class AddLocationToGoldencobraEventsSponsors < ActiveRecord::Migration
  def change
    add_column :goldencobra_events_sponsors, :location_id, :integer

  end
end
