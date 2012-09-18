# == Schema Information
#
# Table name: goldencobra_events_venues
#
#  id          :integer          not null, primary key
#  location_id :integer
#  title       :string(255)
#  description :text
#  link_url    :string(255)
#  phone       :string(255)
#  email       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

module GoldencobraEvents
  class Venue < ActiveRecord::Base
    
    belongs_to :location, :class_name => Goldencobra::Location
    accepts_nested_attributes_for :location

    def location_values
      return self.location.complete_location
    end
  end
end
