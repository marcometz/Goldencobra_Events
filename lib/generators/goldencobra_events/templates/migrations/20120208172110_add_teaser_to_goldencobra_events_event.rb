class AddTeaserToGoldencobraEventsEvent < ActiveRecord::Migration
  def change
    add_column :goldencobra_events_events, :teaser_image_id, :integer

  end
end
