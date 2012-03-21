Rails.application.config.to_prepare do
  Goldencobra::Article.class_eval do
    belongs_to :event, class_name: GoldencobraEvents::Event, foreign_key: "event_id"
    
    
    #Sponsor AddOn
    serialize :sponsor_list
    attr_accessor :sponsor_list_values
    def get_sponsor_sorter(sponsor_id)
      if self.sponsor_list.present?
        self.sponsor_list[sponsor_id.to_s]
      end
    end
    before_save :convert_sponsor_sorter
    def convert_sponsor_sorter
      if self.sponsor_list_values.present?
        self.sponsor_list = {}
        self.sponsor_list_values.each_key do |a|
          self.sponsor_list[a.to_s] = self.sponsor_list_values[a.to_s]
        end
      end
    end
    
    
    #Artist AddOn
    serialize :artist_list
    attr_accessor :artist_list_values
    def get_artist_sorter(artist_id)
      if self.artist_list.present?
        self.artist_list[artist_id.to_s]
      end
    end
    before_save :convert_article_sorter
    def convert_article_sorter
      if self.artist_list_values.present?
        self.artist_list = {}
        self.artist_list_values.each_key do |a|
          self.artist_list[a.to_s] = self.artist_list_values[a.to_s]
        end
      end
    end

  end

end
