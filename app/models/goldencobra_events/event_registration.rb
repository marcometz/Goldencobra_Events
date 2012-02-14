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

module GoldencobraEvents
  class EventRegistration < ActiveRecord::Base
    belongs_to :user, :class_name => User
    belongs_to :event_pricegroup
    
    scope :active, where(:canceled => false)

    before_save :is_registerable?

    def is_registerable?(list_of_registrations=nil)
      #
      # receives array of event_pricegroup_ids and checks them for 
      #
      if list_of_registrations == nil
        list_of_registrations = []
        if self.user && self.user.present? && self.user.event_registration_ids
          list_of_registrations << self.user.event_registration_ids
        end
        list_of_registrations << self.id
      end

      error_msgs = {}
      mybool = true
      list_of_registrations.each do |reg|
      #
      # is registration date valid?
      #
#        if !reg.registration_date_valid
 #         error_msgs << {:error => "Registration date is not valid"}
  #      end
      #
      # is registration possible or is event mutually exclusive?
      #

      #
      # max number of (event) participants reached?
      #
      
      #
      # max number of (pricegroup) participants reached?
      #

      #
      # parent needs_registration? && registration_done?
      #

        mybool = GoldencobraEvents::EventRegistration.find(reg).registration_date_valid
      end
      return mybool
   #   return error_msgs.length > 0 ? false : true
    end


    def self.registration_date_valid
      # Check if current date is valid for registration
      return start_date < Time.now && end_date > Time.now
    end

    def registration_possible?
      # If siblings exist and if they are exclusive
      # Then check their registered? status
      
    end

    def max_number_of_participants_reached?
      
    end

    def parent_registration_done?
      
    end
    
  end
end
