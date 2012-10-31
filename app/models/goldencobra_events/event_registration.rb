# encoding: UTF-8
# == Schema Information
#
# Table name: goldencobra_events_event_registrations
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  event_pricegroup_id :integer
#  canceled            :boolean          default(FALSE)
#  canceled_at         :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  ticket_number       :string(255)
#  invoice_number      :string(255)
#  checkin_status      :string(255)
#

module GoldencobraEvents
  class EventRegistration < ActiveRecord::Base
    belongs_to :user, :class_name => GoldencobraEvents::RegistrationUser
    belongs_to :event_pricegroup
    attr_accessor :session_list_of_ids
    scope :active, where(:canceled => false)
    scope :with_event_id, lambda { |param| joins(:event_pricegroup).where("goldencobra_events_event_pricegroups.event_id = #{param}") }
    CheckIns = ["Bekannt & erster Checkin. Bitte Unterlagen aushändigen.", "Bekannt & wiederholter Checkin. Keine Unterlagen aushändigen."]

    LiquidParser = {}

    before_save :is_registerable?

    def checkin_status_message
      unless self.checkin_status.present?
        self.update_attributes(checkin_status: CheckIns[0])
      else
        self.update_attributes(checkin_status: CheckIns[1])
        self.save
      end
      self.checkin_status
    end

    def is_registerable?(list_of_pricegroup_ids=nil)
      # receives array of event_pricegroup_ids and checks them for
      list_of_ids = []
      if list_of_pricegroup_ids == nil
        if self.user && self.user.present? && self.user.event_registration_ids
          list_of_ids << self.user.event_registrations.map(&:event_pricegroup_id)
        end
        if self.session_list_of_ids.present?
          list_of_ids << self.session_list_of_ids
        end
        list_of_ids << self.event_pricegroup_id
      else
        list_of_ids << list_of_pricegroup_ids
      end

      list_of_ids = list_of_ids.flatten.uniq.compact

      error_msgs = {}
      mybool = true
      list_of_ids.each do |event_pricg|
        epricegroup = GoldencobraEvents::EventPricegroup.find_by_id(event_pricg)
        if epricegroup
          # is registration date valid?
          unless epricegroup.registration_date_valid
            error_msgs[:date_error] = "Registration date of pricegroup is not valid"
          end

          if epricegroup.event.present? && !epricegroup.event.registration_date_valid
            error_msgs[:date_error] = "Registration date of event is not valid"
          end

          # max number of (event) participants reached?
          if epricegroup.event.present? && epricegroup.event.max_number_of_participants_reached?
            error_msgs[:num_of_ev_part_reached] = "Maximum number of participants reached for event '#{epricegroup.event.title}'"
          end

          # max number of (pricegroup) participants reached?
          if epricegroup.max_number_of_participants_reached?
            error_msgs[:num_of_pricegroup_part_reached] = "Maximum number of participants reached for pricegroup '#{epricegroup.title}'"
          end

          # parent needs_registration? && registration_done?
          rtn_val = epricegroup.event.check_for_parent_registrations(list_of_ids) if epricegroup.event.present?
          error_msgs[:parent_error] = rtn_val unless rtn_val == true

          # is registration possible or is event mutually exclusive?
          sib_ex = epricegroup.event.siblings_exclusive?(list_of_ids) if epricegroup.event.present?
          error_msgs[:exclusivity_error] = sib_ex unless sib_ex == true
        end

      end
      return error_msgs.length > 0 ? error_msgs : true
    end

    def self.create_batch(list_of_pricegroup_ids, user)
      if list_of_pricegroup_ids.present? && list_of_pricegroup_ids.count > 0
        ev_reg = GoldencobraEvents::EventRegistration.new
        result = ev_reg.is_registerable?(list_of_pricegroup_ids)
        if result == true
          list_of_pricegroup_ids.each do |reg_id|
            reg = GoldencobraEvents::EventRegistration.find_by_event_pricegroup_id_and_user_id(reg_id,user.id)
            unless reg
              if GoldencobraEvents::EventRegistration.create(:event_pricegroup_id => reg_id, :user_id => user.id, :session_list_of_ids => list_of_pricegroup_ids)
                result = true
              end
            end
          end
        end
        return result
      else
        return false
      end
    end
  end
end
