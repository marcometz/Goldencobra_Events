# == Schema Information
#
# Table name: goldencobra_events_artist_events
#
#  id         :integer          not null, primary key
#  artist_id  :integer
#  event_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module GoldencobraEvents
  class ArtistEvent < ActiveRecord::Base
    belongs_to :artist
    belongs_to :event
  end
end
