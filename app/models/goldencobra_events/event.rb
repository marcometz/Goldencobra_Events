# == Schema Information
#
# Table name: goldencobra_events_events
#
#  id                          :integer(4)      not null, primary key
#  ancestry                    :string(255)
#  title                       :string(255)
#  description                 :text
#  created_at                  :datetime        not null
#  updated_at                  :datetime        not null
#  active                      :boolean(1)      default(TRUE)
#  external_link               :string(255)
#  max_number_of_participators :integer(4)      default(0)
#  type_of_event               :string(255)
#  type_of_registration        :string(255)
#  exclusive                   :boolean(1)      default(FALSE)
#  start_date                  :datetime
#  end_date                    :datetime
#  panel_id                    :integer(4)
#  venue_id                    :integer(4)
#  teaser_image_id             :integer(4)
#

module GoldencobraEvents
  class Event < ActiveRecord::Base

    EventType = ["No Registration needed", "Registration needed", "Webcode needed", "Private event"]
    RegistrationType = ["No cancellation required", "Cancellation required"]

    has_ancestry :orphan_strategy => :restrict
    has_many :articles, :class_name => Goldencobra::Article   #, :foreign_key => "article_id"
    has_many :event_pricegroups
    has_many :pricegroups, :through => :event_pricegroups
    has_many :event_sponsors
    has_many :sponsors, :through => :event_sponsors
    has_many :artist_events
    has_many :artists, :through => :artist_events
    belongs_to :panel
    belongs_to :venue
    belongs_to :teaser_image, :class_name => Goldencobra::Upload, :foreign_key => "teaser_image_id"
    accepts_nested_attributes_for :event_pricegroups
    scope :active, where(:active => true)

    def needs_registration?
      self.type_of_event == "Registration needed"
    end

    def is_registerable?(id_to_check, list_of_registrations)
      #
      # receives array of event_pricegroup_ids and checks them for 
      #

      #
      # is registration date valid?
      #

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
    end

    def registration_date_valid
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
