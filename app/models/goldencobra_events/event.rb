# == Schema Information
#
# Table name: goldencobra_events_events
#
#  id                          :integer          not null, primary key
#  ancestry                    :string(255)
#  title                       :string(255)
#  description                 :text
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  active                      :boolean          default(TRUE)
#  external_link               :string(255)
#  max_number_of_participators :integer          default(0)
#  type_of_event               :string(255)
#  type_of_registration        :string(255)
#  exclusive                   :boolean          default(FALSE)
#  start_date                  :datetime
#  end_date                    :datetime
#  panel_id                    :integer
#  venue_id                    :integer
#  teaser_image_id             :integer
#

module GoldencobraEvents
  class Event < ActiveRecord::Base

    EventType = ["No Registration needed", "Registration needed", "Registration optional"]
    RegistrationType = ["No cancellation required", "Cancellation required"]
    Modultype = {"program" => "Programm", "registration" => "Anmeldung"}

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
    scope :active, where(:active => true).order(:start_date)
    scope :inactive, where(:active => false).order(:start_date)

    scope :parent_ids_in_eq, lambda { |art_id| subtree_of(art_id) }
    search_methods :parent_ids_in_eq

    scope :parent_ids_in, lambda { |art_id| subtree_of(art_id) }
    search_methods :parent_ids_in

    before_save :set_start_end_dates
    def set_start_end_dates
      if self.start_date.blank? && self.parent.present?
        self.start_date = self.parent.start_date
      end
      if self.end_date.blank? && self.parent.present?
        self.end_date = self.parent.end_date
      end
    end

    after_save :init_default_pricegroup
    def init_default_pricegroup
      if self.event_pricegroups.count == 0
        self.event_pricegroups << EventPricegroup.create(:price => 0, :max_number_of_participators => 0)
      end
    end

    def needs_registration?
      self.type_of_event == "Registration needed"
    end

    def registration_optional?
      self.type_of_event == "Registration optional"
    end

    def get_list_of_events_from_event_pricegroup_ids(list_of_event_pricegroup_ids)
      GoldencobraEvents::Event.joins(:event_pricegroups).where("goldencobra_events_event_pricegroups.id in (?)", list_of_event_pricegroup_ids).select("goldencobra_events_events.id")
    end

    def registration_date_valid
      # Check if current date is valid for registration
      if self.end_date
        return self.end_date > Time.now
      else
        return true
      end
    end

    def pricegroups_with_webcode(webcode)
      pricegroups = []
      # Wenn ein Webcode vorhanden ist, soll nur noch diese entsprechende Preisgruppe
      # angezeigt werden.
      # pricegroups << self.event_pricegroups.available.where(:webcode => "")
      pricegroups << self.event_pricegroups.available.where(:webcode => webcode)
      return pricegroups.flatten
    end

    def webcodes
      self.event_pricegroups.select(:webcode).map(&:webcode).map{|a| a.present? == true ? a : true}
    end

    def registration_css_class
      self.type_of_event.to_s.underscore.strip.gsub(" ", "_")
    end

    def has_registerable_childrens?
      result = false
      self.descendants.each do |child|
        result = true if (child.needs_registration? || child.exclusive || child.registration_optional?)
      end
      return result
    end

    def number_of_participators_label
      if self.max_number_of_participators == 0
        "&infin;"
      else
        "#{GoldencobraEvents::EventRegistration.with_event_id(self.id).select("goldencobra_events_event_registrations.id").count}/#{self.max_number_of_participators}"
      end
    end

    def is_visible?(options={})
      result = false
      if options && options[:article].present?
        article = options[:article]
        result = true if article.eventmoduletype == "program"
        if (article.eventmoduletype == "registration" && (self.has_registerable_childrens? || self.needs_registration? || self.registration_optional?))
          if self.webcodes.present?
            if (options[:webcode].present? && self.webcodes.include?(options[:webcode])) || self.webcodes.include?(true)
              result = true
            end
          else
            result = true
          end
        end
      end
      return result
    end

    def check_for_parent_registrations(list_of_ids)
      # does parent need a registration? Is registration already in system?
      errors = []
      list_of_event_ids = get_list_of_events_from_event_pricegroup_ids(list_of_ids)
      list_of_ids_as_array = []
      self.ancestors.each do |a|
        if a.needs_registration?
          list_of_event_ids.each do |b|
            list_of_ids_as_array << b.id
          end
          list_of_ids_as_array = list_of_ids_as_array.flatten.uniq
          errors << a.id unless list_of_ids_as_array.include?(a.id)
        end
      end
      return errors.blank? ? true : errors
    end

    def max_number_of_participants_reached?
      if self.max_number_of_participators == 0 || GoldencobraEvents::EventRegistration.joins(:event_pricegroup)
                                             .where("goldencobra_events_event_pricegroups.event_id = #{self.id}")
                                             .select("goldencobra_events_event_registrations.id")
                                             .count < self.max_number_of_participators
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

    def title_for_invoice
      self.title + " des Tagesspiegels"
    end

    def date
      if self.start_date.present? && self.end_date.present?
        self.start_date.strftime("%d.%m.").to_s + "-" + self.end_date.strftime("%d.%m.%Y").to_s
      elsif self.start_date.present?
        self.start_date.strftime("%d.%m.").to_s
      else
        ""
      end
    end
  end
end


#parent           Returns the parent of the record, nil for a root node
#parent_id        Returns the id of the parent of the record, nil for a root node
#root             Returns the root of the tree the record is in, self for a root node
#root_id          Returns the id of the root of the tree the record is in
#is_root?         Returns true if the record is a root node, false otherwise
#ancestor_ids     Returns a list of ancestor ids, starting with the root id and ending with the parent id
#ancestors        Scopes the model on ancestors of the record
#path_ids         Returns a list the path ids, starting with the root id and ending with the node's own id
#path             Scopes model on path records of the record
#children         Scopes the model on children of the record
#child_ids        Returns a list of child ids
#has_children?    Returns true if the record has any children, false otherwise
#is_childless?    Returns true is the record has no childen, false otherwise
#siblings         Scopes the model on siblings of the record, the record itself is included
#sibling_ids      Returns a list of sibling ids
#has_siblings?    Returns true if the record's parent has more than one child
#is_only_child?   Returns true if the record is the only child of its parent
#descendants      Scopes the model on direct and indirect children of the record
#descendant_ids   Returns a list of a descendant ids
#subtree          Scopes the model on descendants and itself
#subtree_ids      Returns a list of all ids in the record's subtree
#depth            Return the depth of the node, root nodes are at depth 0
