# == Schema Information
#
# Table name: goldencobra_events_artists
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)
#  description :string(255)
#  url_link    :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  telephone   :string(255)
#  email       :string(255)
#  location_id :integer(4)
#

module GoldencobraEvents
  class Artist < ActiveRecord::Base
    belongs_to :location, :class_name => Goldencobra::Location
    accepts_nested_attributes_for :location
    has_many :artist_events
    has_many :events, :through => :artist_events
    has_many :artist_sponsors
    has_many :sponsors, :through => :artist_sponsors
    validates_presence_of :title

    def complete_artist_name
      result = ""
      result += "#{self.title}" if self.title.present? 
      result += ", #{self.description[0..20]}..." if self.description.present?
      self.sponsors.each do |s|
        result += ", #{s.title}"
      end
      return result
    end
  end
end