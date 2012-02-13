module GoldencobraEvents
  class EventRegistration < ActiveRecord::Base
    belongs_to :user, :class_name => User
    belongs_to :event_pricegroup
    
    scope :active, where(:canceled => false)
    
  end
end
