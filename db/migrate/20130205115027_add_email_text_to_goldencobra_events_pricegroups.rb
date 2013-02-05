class AddEmailTextToGoldencobraEventsPricegroups < ActiveRecord::Migration
  def change
    add_column :goldencobra_events_pricegroups, :email_text, :text
  end
end
