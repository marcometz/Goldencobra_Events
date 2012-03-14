Rails.application.config.to_prepare do
  Goldencobra::Article.class_eval do
    belongs_to :event, class_name: GoldencobraEvents::Event, foreign_key: "event_id"
    serialize :artist_list
    attr_accessor :artist_list_values
    
    def get_artist_sorter(artist_id)
      if self.artist_list.present?
        self.artist_list[artist_id.to_s]
      end
    end
    
    before_save :convert_article_sorter

    def convert_article_sorter
      if self.artist_list.blank?
        self.artist_list = {}
      end
      if self.artist_list_values.present?
        self.artist_list_values.each_key do |a|
          self.artist_list[a] = self.artist_list_values[a]
        end
      end
    end

  end

end
