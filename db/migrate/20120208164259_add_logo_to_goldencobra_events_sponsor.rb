class AddLogoToGoldencobraEventsSponsor < ActiveRecord::Migration
  def change
    add_column :goldencobra_events_sponsors, :logo_id, :integer

  end
end
