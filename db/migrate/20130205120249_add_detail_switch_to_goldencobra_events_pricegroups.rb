class AddDetailSwitchToGoldencobraEventsPricegroups < ActiveRecord::Migration
  def change
    add_column :goldencobra_events_pricegroups, :show_details_in_email, :boolean, default: true
  end
end
