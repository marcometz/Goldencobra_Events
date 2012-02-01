class AddEventToArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :event_id, :integer

  end
end
