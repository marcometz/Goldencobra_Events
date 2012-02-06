# This migration comes from goldencobra_events (originally 20120201150701)
class AddEventToArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :event_id, :integer

  end
end
