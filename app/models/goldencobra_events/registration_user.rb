module GoldencobraEvents
  class RegistrationUser < ActiveRecord::Base
    has_many :event_registrations, class_name: GoldencobraEvents::EventRegistration, :foreign_key => "user_id"
    belongs_to :company, :class_name => GoldencobraEvents::Company
    belongs_to :user, :class_name => User
    
    def total_price
      total_price = 0
      self.event_registrations.each do |e|
        total_price += e.event_pricegroup.price
      end
      return total_price
    end
    
  end
end
