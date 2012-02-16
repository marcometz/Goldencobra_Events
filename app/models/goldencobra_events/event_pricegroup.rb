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
#  available                   :boolean(1)      default(TRUE)
#  created_at                  :datetime        not null
#  updated_at                  :datetime        not null
#  webcode                     :string(255)
#

module GoldencobraEvents
  class EventPricegroup < ActiveRecord::Base
    belongs_to :event
    belongs_to :pricegroup
    attr_accessor :price_raw
    attr_accessible :price_raw, :pricegroup_id, :price, 
      :max_number_of_participators, :cancelation_until, :start_reservation,
      :end_reservation, :available, :webcode
    scope :available, where(:available => true)

    before_save :convert_price_raw

    def title
      self.pricegroup.title
    end

    def registration_date_valid
      # Check if current date is valid for registration
      return self.event.start_date < Time.now && 
             self.event.end_date > Time.now if self.event
    end


    def max_number_of_participants_reached?
      if GoldencobraEvents::EventRegistration.where("event_pricegroup_id = #{self.id}")
                                             .select("goldencobra_events_event_registrations.id")
                                             .count <= self.max_number_of_participators
        return false
      else
        return true
      end
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
