# This migration comes from goldencobra_events (originally 20120202100010)
class CreateGoldencobraEventsPricegroups < ActiveRecord::Migration
  def change
    create_table :goldencobra_events_pricegroups do |t|
      t.string :title

      t.timestamps
    end
  end
end
