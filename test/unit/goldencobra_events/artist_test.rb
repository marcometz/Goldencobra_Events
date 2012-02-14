# == Schema Information
#
# Table name: goldencobra_events_artists
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)
#  description :text
#  url_link    :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  telephone   :string(255)
#  email       :string(255)
#  location_id :integer(4)
#

require 'test_helper'

module GoldencobraEvents
  class ArtistTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
