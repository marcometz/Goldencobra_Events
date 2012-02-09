module GoldencobraEvents
  class SponsorImage < ActiveRecord::Base
    
    belongs_to :sponsor
    belongs_to :image, :class_name => Goldencobra::Upload, :foreign_key => "image_id"
    
  end
end
