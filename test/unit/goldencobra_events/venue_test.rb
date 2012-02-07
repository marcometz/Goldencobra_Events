# == Schema Information
#
# Table name: goldencobra_events_venues
#
#  id          :integer(4)      not null, primary key
#  location_id :integer(4)
#  title       :string(255)
#  description :text
#  link_url    :string(255)
#  phone       :string(255)
#  email       :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

require 'test_helper'

module GoldencobraEvents
  class VenueTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
