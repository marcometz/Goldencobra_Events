# == Schema Information
#
# Table name: goldencobra_events_artist_sponsors
#
#  id         :integer          not null, primary key
#  artist_id  :integer
#  sponsor_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module GoldencobraEvents
  class ArtistSponsor < ActiveRecord::Base
    belongs_to :artist
    belongs_to :sponsor
  end
end
