# == Schema Information
#
# Table name: goldencobra_events_event_registrations
#
#  id                  :integer(4)      not null, primary key
#  user_id             :integer(4)
#  event_pricegroup_id :integer(4)
#  canceled            :boolean(1)      default(FALSE)
#  canceled_at         :datetime
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#

require 'test_helper'

module GoldencobraEvents
  class EventRegistrationTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
