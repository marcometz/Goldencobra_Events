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

require 'test_helper'

module GoldencobraEvents
  class ArtistSponsorTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
