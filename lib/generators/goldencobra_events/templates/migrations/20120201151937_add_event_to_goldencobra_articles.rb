class AddEventToGoldencobraArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :event_levels, :integer, :default => 0

  end
end
