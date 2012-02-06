# This migration comes from goldencobra_events (originally 20120201151937)
class AddEventToGoldencobraArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :event_levels, :integer, :default => 0

  end
end
