# == Schema Information
#
# Table name: goldencobra_events_event_sponsors
#
#  id         :integer          not null, primary key
#  event_id   :integer
#  sponsor_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module GoldencobraEvents
  class EventSponsor < ActiveRecord::Base
    belongs_to :sponsor
    belongs_to :event
  end
end
