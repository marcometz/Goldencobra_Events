# == Schema Information
#
# Table name: goldencobra_events_registration_users
#
#  id                     :integer(4)      not null, primary key
#  user_id                :integer(4)
#  gender                 :boolean(1)
#  email                  :string(255)
#  title                  :string(255)
#  firstname              :string(255)
#  lastname               :string(255)
#  function               :string(255)
#  phone                  :string(255)
#  agb                    :boolean(1)
#  company_id             :integer(4)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  type_of_registration   :string(255)     default("Webseite")
#  comment                :text
#  invoice_sent           :datetime
#  payed_on               :datetime
#  first_reminder_sent    :datetime
#  second_reminder_sent   :datetime
#  active                 :boolean(1)      default(TRUE)
#  billing_gender         :boolean(1)
#  billing_title          :string(255)
#  billing_firstname      :string(255)
#  billing_lastname       :string(255)
#  billing_function       :string(255)
#  billing_phone          :string(255)
#  billing_company_id     :integer(4)
#  billing_contact_person :string(255)
#  billing_department     :string(255)
#

module GoldencobraEvents
  class RegistrationUser < ActiveRecord::Base
    has_many :event_registrations, class_name: GoldencobraEvents::EventRegistration, :foreign_key => "user_id"
    belongs_to :company, :class_name => GoldencobraEvents::Company
    belongs_to :billing_company, :class_name => GoldencobraEvents::Company
    belongs_to :user, :class_name => User
    has_many :vita_steps, :as => :loggable, :class_name => Goldencobra::Vita
    attr_accessor :should_not_initialize
    after_create :init_default_data

    RegistrationTypes = ["Webseite", "Fax", "Email", "Telefon", "Importer", "Brieftaube", "anderer Weg"]

    accepts_nested_attributes_for :company
    accepts_nested_attributes_for :billing_company
    accepts_nested_attributes_for :event_registrations, :allow_destroy => true
    accepts_nested_attributes_for :vita_steps, allow_destroy: true, reject_if: lambda { |a| a[:description].blank? }
    liquid_methods :gender, :email, :title, :firstname, :lastname, :function, :anrede

    scope :active, where(:active => true)
    scope :storno, where(:active => false)
    scope :unpaid, where(:payed_on => nil )
    scope :invoice_not_send, where(:invoice_sent => nil )

    search_methods :type_of_registration_not_eq
    scope :type_of_registration_not_eq, lambda { |param| where("type_of_registration <> '#{param}'") }

    search_methods :total_price_eq
    scope :total_price_eq, lambda { |param|
      #joins(:event_registrations => :event_pricegroup)
      #.group("goldencobra_events_registration_users.id")
      #.select("goldencobra_events_registration_users.id,firstname,lastname,email,type_of_registration,goldencobra_events_registration_users.created_at,goldencobra_events_registration_users.updated_at,SUM(price) AS summe")
      #.where("summe = #{param.to_f}")
      results = RegistrationUser.joins(:event_registrations => :event_pricegroup).group("goldencobra_events_registration_users.id").select("goldencobra_events_registration_users.id,SUM(price) AS summe")
      .map{|a| a.id if a.summe == param.to_f}
      where("id in (?)", results)
    }

    search_methods :total_price_gt
    scope :total_price_gt, lambda { |param|
      results = RegistrationUser.joins(:event_registrations => :event_pricegroup).group("goldencobra_events_registration_users.id").select("goldencobra_events_registration_users.id,SUM(price) AS summe")
      .map{|a| a.id if a.summe > param.to_f}
      where("id in (?)", results)
    }

    search_methods :total_price_lt
    scope :total_price_lt, lambda { |param|
      results = RegistrationUser.joins(:event_registrations => :event_pricegroup)
      .group("goldencobra_events_registration_users.id")
      .select("goldencobra_events_registration_users.id,SUM(price) AS summe")
      .map{|a| a.id if a.summe < param.to_f}
      where("id in (?)", results)
    }

    def cancel_reservation!
      if self.active == true
        self.active = false
        self.vita_steps << Goldencobra::Vita.create(:title => "Registration canceled", :description => "no confirmation mail sent")
        self.save
      end
    end

    def reactivate_reservation!
      if self.active == false
        self.active = true
        self.vita_steps << Goldencobra::Vita.create(:title => "Registration reactivated", :description => "no confirmation mail sent")
        self.save
      end
    end

    def anrede
      if self.gender == true
        "Sehr geehrter Herr #{self.title} #{self.lastname}"
      else
        "Sehr geehrte Frau #{self.title} #{self.lastname}"
      end
    end

    def total_price
      total_price = 0
      self.event_registrations.each do |e|
        total_price += e.event_pricegroup.price if e.event_pricegroup && e.event_pricegroup.price
      end
      return total_price
    end

    def registration_emails
      self.vita_steps.where(title: "Mail delivered: registration confirmation")
    end

    def last_email_send
      emails = self.registration_emails

      if emails.empty?
        self.type_of_registration == "Webseite" ? self.created_at : nil
      else
        emails.order("created_at DESC").first.created_at
      end
    end

    def init_default_data
      # zusätzlicher Parameter 'should_not_initialize' wird im events_controller gesetzt,
      # sofern ein RegistrationUser für die Session erzeugt wird. Ansonsten wird er nicht
      # benötigt. Der after_initialize callback wird benötigt für manuelles Erstellen
      # eines RegistrationUsers im ActiveAdmin Backend.
      unless self.should_not_initialize.present? && self.should_not_initialize == true
        billing_company = GoldencobraEvents::Company.new if self.billing_company_id.blank?
        billing_company.location = Goldencobra::Location.new if billing_company.present? && billing_company.location
        self.billing_company = billing_company
        self.save
      end
    end
  end
end

