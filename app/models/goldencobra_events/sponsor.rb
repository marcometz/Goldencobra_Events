# == Schema Information
#
# Table name: goldencobra_events_sponsors
#
#  id                  :integer(4)      not null, primary key
#  title               :string(255)
#  description         :text
#  link_url            :string(255)
#  size_of_sponsorship :string(255)
#  type_of_sponsorship :string(255)
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#  location_id         :integer(4)
#  telephone           :string(255)
#  email               :string(255)
#  logo_id             :integer(4)
#

module GoldencobraEvents
  class Sponsor < ActiveRecord::Base
    SponsorshipSize = ["Bronze", "Silver", "Gold"]
    has_many :event_sponsors
    has_many :events, :through => :event_sponsors
    has_many :panel_sponsors
    has_many :panels, :through => :panel_sponsors
    has_many :artist_sponsors
    has_many :artists, :through => :artist_sponsors
    belongs_to :location, :class_name => Goldencobra::Location

    #Imagegallery of an sponsor
    has_many :images, :through => :sponsor_images, :class_name => Goldencobra::Upload
    has_many :sponsor_images
    
    #a single Image as an Logo
    belongs_to :logo, :class_name => Goldencobra::Upload, :foreign_key => "logo_id"

    belongs_to :location, :class_name => Goldencobra::Location
    accepts_nested_attributes_for :sponsor_images    
    accepts_nested_attributes_for :location
    
    if ActiveRecord::Base.connection.table_exists?("goldencobra_settings")
      after_save Goldencobra::Setting.new
      after_destroy Goldencobra::Setting.new
    end
    
    
 end
end
