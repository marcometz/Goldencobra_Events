class AddEventmoduletypeToGoldencobraArticles < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :eventmoduletype, :string
  end
end
