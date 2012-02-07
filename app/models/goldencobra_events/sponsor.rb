# == Schema Information
#
# Table name: goldencobra_events_sponsors
#
#  id                  :integer(4)      not null, primary key
#  title               :string(255)
#  description         :string(255)
#  link_url            :string(255)
#  size_of_sponsorship :string(255)
#  type_of_sponsorship :string(255)
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#  location_id         :integer(4)
#  telephone           :string(255)
#  email               :string(255)
#

module GoldencobraEvents
  class Sponsor < ActiveRecord::Base
    SponsorshipSize = ["Bronze", "Silver", "Gold"]
    has_many :event_sponsors
    has_many :events, :through => :event_sponsors
    has_many :panel_sponsors
    has_many :panels, :through => :panel_sponsors
    belongs_to :location, :class_name => Goldencobra::Location
    accepts_nested_attributes_for :location
 end
end
