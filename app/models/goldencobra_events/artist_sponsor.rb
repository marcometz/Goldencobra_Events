# == Schema Information
#
# Table name: goldencobra_events_artist_sponsors
#
#  id         :integer(4)      not null, primary key
#  artist_id  :integer(4)
#  sponsor_id :integer(4)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

module GoldencobraEvents
  class ArtistSponsor < ActiveRecord::Base
    belongs_to :artist
    belongs_to :sponsor
  end
end
