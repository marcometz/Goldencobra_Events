class ChangeStringToTextGoldencobraEventsArtists < ActiveRecord::Migration
   def up
    change_table :goldencobra_events_artists do |t|
      t.change :description, :text
    end
  end

  def down
    change_table :goldencobra_events_artists do |t|
     t.change :description, :string
   end
 end
end
