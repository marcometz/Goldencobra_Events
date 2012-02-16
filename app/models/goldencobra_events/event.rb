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

    def get_list_of_events_from_event_pricegroup_ids(list_of_event_pricegroup_ids)
      GoldencobraEvents::Event.joins(:event_pricegroups).where("goldencobra_events_event_pricegroups.id in (?)", list_of_event_pricegroup_ids).select("goldencobra_events_events.id")
    end

    def check_for_parent_registrations(list_of_ids)
      # does parent need a registration? Is registration already in system?
      errors = []
      list_of_event_ids = get_list_of_events_from_event_pricegroup_ids(list_of_ids)
      self.ancestors.each do |a|
        if a.needs_registration?
          errors << a.id unless list_of_event_ids.include?(a.id)
        end
      end
      return errors.blank? ? true : errors
    end

    def max_number_of_participants_reached?
      if GoldencobraEvents::EventRegistration.joins(:event_pricegroup)
                                             .where("goldencobra_events_event_pricegroups.event_id = #{self.id}")
                                             .select("goldencobra_events_event_registrations.id")
                                             .count <= self.max_number_of_participators
        return false
      else
        return true
      end
    end

    def siblings_exclusive?(list_of_ids)
      errors = []
      if self.parent.present? && self.parent.exclusive && self.has_siblings?
        list_of_event_ids = get_list_of_events_from_event_pricegroup_ids(list_of_ids)
        self.siblings.each do |s|
          if s.exclusive?
            errors << s.id unless list_of_event_ids.include?(s.id)
          end
        end
      end
      return errors.blank? ? true : errors
    end
  end
end
