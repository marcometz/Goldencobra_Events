# == Schema Information
#
# Table name: goldencobra_events_event_sponsors
#
#  id         :integer(4)      not null, primary key
#  event_id   :integer(4)
#  sponsor_id :integer(4)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

module GoldencobraEvents
  class EventSponsor < ActiveRecord::Base
    belongs_to :sponsor
    belongs_to :event
  end
end
