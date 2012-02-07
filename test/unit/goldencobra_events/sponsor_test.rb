# == Schema Information
#
# Table name: goldencobra_events_sponsors
#
#  id                  :integer(4)      not null, primary key
#  title               :string(255)
#  description         :string(255)
#  link_url            :string(255)
#  size_of_sponsorship :string(255)
#  type_of_sponsorship :string(255)
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#  location_id         :integer(4)
#  telephone           :string(255)
#  email               :string(255)
#

require 'test_helper'

module GoldencobraEvents
  class SponsorTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
