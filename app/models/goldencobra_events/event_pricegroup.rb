# == Schema Information
#
# Table name: goldencobra_events_event_pricegroups
#
#  id                          :integer(4)      not null, primary key
#  event_id                    :integer(4)
#  pricegroup_id               :integer(4)
#  price                       :float           default(0.0)
#  max_number_of_participators :integer(4)      default(0)
#  cancelation_until           :datetime
#  start_reservation           :datetime
#  end_reservation             :datetime
#  available                   :boolean(1)      default(FALSE)
#  created_at                  :datetime        not null
#  updated_at                  :datetime        not null
#

module GoldencobraEvents
  class EventPricegroup < ActiveRecord::Base
    belongs_to :event
    belongs_to :pricegroup
  end
end
