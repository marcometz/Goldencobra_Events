# == Schema Information
#
# Table name: goldencobra_events_event_pricegroups
#
#  id                          :integer          not null, primary key
#  event_id                    :integer
#  pricegroup_id               :integer
#  price                       :float            default(0.0)
#  max_number_of_participators :integer          default(0)
#  cancelation_until           :datetime
#  start_reservation           :datetime
#  end_reservation             :datetime
#  available                   :boolean          default(TRUE)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  webcode                     :string(255)
#  description                 :text
#

module GoldencobraEvents
  class EventPricegroup < ActiveRecord::Base
    attr_accessible :event_id, :pricegroup_id, :price, :price_raw, :max_number_of_participators, :cancelation_until, :start_reservation, :end_reservation, :available, :webcode, :description

    belongs_to :event
    belongs_to :pricegroup
    has_many :event_registrations, :class_name => GoldencobraEvents::EventRegistration
    attr_accessor :price_raw
    scope :available, where(:available => true)
    scope :publicly_available, where(:webcode => "")
    before_save :convert_price_raw
    scope :sorted, order("goldencobra_events_events.start_date").joins(:event)

    validate :validate_date_range
    after_initialize :set_default_available

    def set_default_available
      if self.new_record?
        default_available = Goldencobra::Setting.for_key("goldencobra_events.event_pricegroup.available.default")
        if default_available.present? && default_available == "false"
          self.available = false
        end
      end
    end

    def validate_date_range
      if self.start_reservation && self.end_reservation && self.start_reservation >= self.end_reservation
        errors.add(:start_reservation, I18n.t('active_admin.errors.event_pricegroup.date_error'))
      end
    end

    def title
      self.pricegroup.title if self.pricegroup
    end

    def brutto_price
      self.price + (self.price / 100 * 19)
    end

    def number_of_participators_label
      if max_number_of_participators == 0
        "&infin;"
      else
        "#{GoldencobraEvents::EventRegistration.where("event_pricegroup_id = #{self.id}").select("goldencobra_events_event_registrations.id").count}/#{max_number_of_participators}"
      end

    end

    def registration_date_valid
      # Check if current date is valid for registration
      if self.start_reservation != self.end_reservation
        return self.start_reservation <= Time.now && Time.now <= self.end_reservation
      else
        return true
      end
    end


    def max_number_of_participants_reached?
      if self.max_number_of_participators == 0 || GoldencobraEvents::EventRegistration.where("event_pricegroup_id = #{self.id}")
                                             .select("goldencobra_events_event_registrations.id")
                                             .count < self.max_number_of_participators
        return false
      else
        return true
      end
    end

    def self.bookable
      GoldencobraEvents::EventPricegroup.where('start_reservation < ? AND ? < end_reservation', Time.now.utc, Time.now.utc)
    end

    private
    def convert_price_raw
      if price_raw.present? && price_raw.length > 0
        position_comma = price_raw.index(/[,]/)
        position_point = price_raw.index(/[.]/)
        if position_comma && position_point
          #Checks if number delimiter is european and strips and changes to american format. Finally saves it as float
          if position_point < position_comma
            #european delimitter
            self.price = price_raw.gsub(".","").gsub(",",".").to_f
          else
            #american delimitter
            self.price = price_raw.gsub(",","").to_f
          end
        elsif position_comma && !position_point
          self.price = price_raw.gsub(",",".").to_f
        else !position_comma && position_point
          self.price = price_raw.to_f
        end
      end
    end
  end
end
