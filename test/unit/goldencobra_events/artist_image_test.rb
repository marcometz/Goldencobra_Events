# == Schema Information
#
# Table name: goldencobra_events_artist_images
#
#  id         :integer(4)      not null, primary key
#  image_id   :integer(4)
#  artist_id  :integer(4)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'test_helper'

module GoldencobraEvents
  class ArtistImageTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
