class AddArtistListValuesToGoldencobraArticle < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :event_for_artists_id, :integer

    add_column :goldencobra_articles, :event_for_artists_levels, :integer

  end
end
