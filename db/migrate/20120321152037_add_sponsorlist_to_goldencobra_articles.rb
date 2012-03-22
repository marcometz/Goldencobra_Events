class AddSponsorlistToGoldencobraArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :sponsor_list, :text
    add_column :goldencobra_articles, :event_for_sponsor_id, :integer
    add_column :goldencobra_articles, :event_for_sponsor_levels, :integer, :default => 0
  end
end
