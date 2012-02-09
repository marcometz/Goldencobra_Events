module GoldencobraEvents
  class ArtistSponsor < ActiveRecord::Base
    belongs_to :artist
    belongs_to :sponsor
  end
end
