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
      # receives array of event_pricegroup_ids and checks them for 
      list_of_ids = []
      if list_of_registrations == nil
        if self.user && self.user.present? && self.user.event_registration_ids
          list_of_ids << self.user.event_registration_ids
        end
        list_of_ids << self.id
      else
        list_of_ids = list_of_registrations
      end

      list_of_ids = list_of_ids.flatten.uniq

      error_msgs = {}
      mybool = true
      list_of_ids.each do |reg|
        ereg = GoldencobraEvents::EventRegistration.find_by_id(reg)
        if ereg
          # is registration date valid?
          unless ereg.registration_date_valid
            error_msgs[:date_error] = "Registration date is not valid"
          end

          # max number of (event) participants reached?
          if ereg.max_number_of_events_participants_reached?
            error_msgs[:num_of_ev_part_reached] = "Maximum number of participants reached for #{ereg.event_pricegroup.event.title}"
          end

          # max number of (pricegroup) participants reached?
          if ereg.max_number_of_pricegroup_participants_reached?
            error_msgs[:num_of_pricegroup_part_reached] = "Maximum number of participants reached for #{ereg.event_pricegroup.pricegroup.title}"
          end
          
          # parent needs_registration? && registration_done?
          if ereg.parent_registration_completed? != true
            rtn_val = ereg.parent_registration_completed?
            error_msgs[:parent_error] = rtn_val
          end
        end

        # is registration possible or is event mutually exclusive?
      end
      return error_msgs.length > 0 ? error_msgs : true
    end

    def registration_date_valid
      # Check if current date is valid for registration
      return self.event_pricegroup.event.start_date < Time.now && 
             self.event_pricegroup.event.end_date > Time.now if self.event_pricegroup && self.event_pricegroup.event
    end

    def registration_possible?
      # If siblings exist and if they are exclusive
      # Then check their registered? status
    end

    def max_number_of_events_participants_reached?
      event = self.event_pricegroup.event
      if GoldencobraEvents::EventRegistration.joins(:event_pricegroup)
                                             .where("goldencobra_events_event_pricegroups.event_id = #{event.id}")
                                             .select("goldencobra_events_event_registrations.id")
                                             .count <= event.max_number_of_participators
        return false
      else
        return true
      end
    end

    def max_number_of_pricegroup_participants_reached?
      if GoldencobraEvents::EventRegistration.where("event_pricegroup_id = #{self.event_pricegroup_id}")
                                             .select("goldencobra_events_event_registrations.id")
                                             .count <= self.event_pricegroup.max_number_of_participators
        return false
      else
        return true
      end
    end

    def parent_registration_completed?(*args)
      # does parent need a registration? Is registration already in system?
      a = []
      a.concat(args)
      event = self.event_pricegroup.event
      if event.parent.present?
        parent = event.parent
        if parent.type_of_event == "Registration needed"
          if self.user && self.user.present?
            # If user and parent with "Registration needed" present, look for EventRegistration for User/Parent
            if GoldencobraEvents::EventRegistration.joins(:event_pricegroup)
                                                   .where("goldencobra_events_event_registrations.user_id = #{self.user.id} AND goldencobra_events_event_pricegroups.event_id = #{parent.id}")
                                                   .select("goldencobra_events_event_registrations.id")
                                                   .count < 1
              a << parent.id
            end
            if parent.parent.present?
              args = a.join(",")
              parent.parent_registration_completed?(args)
            else
              return a
            end
          end
        else # "parent doesn't need a registration"
          if parent.parent.present?
            parent.parent_registration_completed?(a.join(","))
          else
            return a.length > 0 ? a : true
          end
        end
      else # no parent present
        return true
      end
    end
  end
end
