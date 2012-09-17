class AddArtistListToGoldencobraArticle < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :artist_list, :text

  end
end
