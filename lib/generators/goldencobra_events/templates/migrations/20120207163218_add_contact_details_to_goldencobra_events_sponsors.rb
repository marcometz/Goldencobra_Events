class AddContactDetailsToGoldencobraEventsSponsors < ActiveRecord::Migration
  def change
    add_column :goldencobra_events_sponsors, :telephone, :string

    add_column :goldencobra_events_sponsors, :email, :string

  end
end
