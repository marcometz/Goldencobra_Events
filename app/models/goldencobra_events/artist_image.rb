module GoldencobraEvents
  class ArtistImage < ActiveRecord::Base
    belongs_to :artist
    belongs_to :image, :class_name => Goldencobra::Upload, :foreign_key => "image_id"
  end
end
