class AddContactdetailsToGoldencobraEventsArtists < ActiveRecord::Migration
  def change
    add_column :goldencobra_events_artists, :telephone, :string

    add_column :goldencobra_events_artists, :email, :string

  end
end
