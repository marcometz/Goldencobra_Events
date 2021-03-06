# == Schema Information
#
# Table name: goldencobra_events_registration_users
#
#  id                     :integer          not null, primary key
#  user_id                :integer
#  gender                 :boolean
#  email                  :string(255)
#  title                  :string(255)
#  firstname              :string(255)
#  lastname               :string(255)
#  function               :string(255)
#  phone                  :string(255)
#  agb                    :boolean
#  company_id             :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  type_of_registration   :string(255)      default("Webseite")
#  comment                :text
#  invoice_sent           :datetime
#  payed_on               :datetime
#  first_reminder_sent    :datetime
#  second_reminder_sent   :datetime
#  active                 :boolean          default(TRUE)
#  billing_gender         :boolean
#  billing_title          :string(255)
#  billing_firstname      :string(255)
#  billing_lastname       :string(255)
#  billing_function       :string(255)
#  billing_phone          :string(255)
#  billing_company_id     :integer
#  billing_contact_person :string(255)
#  billing_department     :string(255)
#  invoice_number         :string(255)
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
    after_commit :check_for_master_data
    validates_presence_of :email, :firstname, :lastname
    validates_inclusion_of :gender, :in => [true, false]

    RegistrationTypes = ["anderer Weg", "Webseite", "Fax", "Email", "Telefon", "Importer", "Brieftaube"]

    accepts_nested_attributes_for :company
    accepts_nested_attributes_for :billing_company
    accepts_nested_attributes_for :event_registrations, allow_destroy: true, :reject_if => lambda { |a| a[:event_pricegroup_id].blank? }
    accepts_nested_attributes_for :vita_steps, allow_destroy: true, reject_if: lambda { |a| a[:description].blank? }
    liquid_methods :gender, :email, :title, :firstname, :lastname, :function, :anrede

    scope :active, where(:active => true)
    scope :storno, where(:active => false)
    scope :unpayed, where(:payed_on => nil )
    scope :payed, where('payed_on IS NOT NULL')
    scope :invoice_not_send, where(:invoice_sent => nil )
    scope :current_event, where("goldencobra_events_registration_users.active = 1").where("goldencobra_events_events.ancestry IS NULL").where(:goldencobra_events_events => {:active => true} ).joins(:event_registrations => {:event_pricegroup => :event}).uniq

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

    scope :pricegroup_name_eq, lambda { |search_term| joins(:event_registrations => {:event_pricegroup => :pricegroup}).where("goldencobra_events_pricegroups.title LIKE '%#{search_term}%' AND goldencobra_events_registration_users.active = true") }
    search_methods :pricegroup_name_eq

    def cancel_reservation!
      if self.active == true
        self.active = false
        self.vita_steps << Goldencobra::Vita.create(:title => "Registration canceled", :description => "no confirmation mail sent")
        self.user.vita_steps << Goldencobra::Vita.create(:title => "Registration canceled", :description => "no confirmation mail sent") if self.user.present?
        self.save
        GoldencobraEvents::EventRegistrationMailer.storno_email(self.id).deliver
      end
    end

    def set_invoice_date(date)
      self.update_attributes(invoice_sent: date)
    end

    def generate_cancellation
      if self.event_registrations.any?
        require 'pdfkit'
        invoice_numb = self.master_event_registration.invoice_number
        html = ActionController::Base.new.render_to_string(
                                      template: 'templates/invoice/cancellation', layout: false,
                                        locals: {
            user: self,
            event: self.master_event_registration.event_pricegroup.event,
            invoice_date: self.invoice_sent.present? ? self.invoice_sent.strftime("%d.%m.%Y") : Time.now.strftime("%d.%m.%Y"),
            invoice_number: invoice_numb
            })
        kit = PDFKit.new(html, :page_size => 'Letter')
        if File.exists?("#{Rails.root}/public/system/invoices/cancellation_#{invoice_numb}.pdf")
          File.delete("#{Rails.root}/public/system/invoices/cancellation_#{invoice_numb}.pdf")
        end
        kit.to_file("#{Rails.root}/public/system/invoices/cancellation_#{invoice_numb}.pdf")
      end
    end

    def generate_reminder(cat)
      if self.event_registrations.any? && cat.present?
        category = cat.to_s
        require 'pdfkit'
        re_date = Time.now + 14.days
        invoice_numb = self.master_event_registration.invoice_number
        html = ActionController::Base.new.render_to_string(
                              template: "templates/invoice/reminder_#{category}",
                              layout: false,
                              locals: {
            user: self,
            event: self.master_event_registration.event_pricegroup.event,
            invoice_date: self.invoice_sent.present? ? self.invoice_sent.strftime("%d.%m.%Y") : Time.now.strftime("%d.%m.%Y"),
            reminder_date: re_date.strftime("%d.%m.%Y"),
            invoice_number: invoice_numb
            })
        kit = PDFKit.new(html, :page_size => 'Letter')
        if File.exists?("#{Rails.root}/public/system/invoices/reminder_#{category}_#{invoice_numb}.pdf")
          File.delete("#{Rails.root}/public/system/invoices/reminder_#{category}_#{invoice_numb}.pdf")
        end
        kit.to_file("#{Rails.root}/public/system/invoices/reminder_#{category}_#{invoice_numb}.pdf")
      end
    end

    def reactivate_reservation!
      if self.active == false
        self.active = true
        self.vita_steps << Goldencobra::Vita.create(:title => "Registration reactivated", :description => "no confirmation mail sent")
        self.user.vita_steps << Goldencobra::Vita.create(:title => "Registration reactivated", :description => "no confirmation mail sent") if self.user.present?
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

    def full_name
      self.firstname + " " + self.lastname
    end

    def full_billing_name_with_gender_and_title
      s = ""
      if self.billing_gender
        s << "Herr"
      else
        s << "Frau"
      end
      if self.billing_title.present?
        s << " #{self.billing_title}"
      end
      s << " #{self.billing_firstname} #{self.billing_lastname}"
      if self.billing_firstname.blank? && self.billing_lastname.blank?
        s = self.full_name_with_gender_and_title
      end
      s
    end

    def full_name_with_gender_and_title
      if self.gender
        s = "Herr"
      else
        s = "Frau"
      end
      if self.title.present?
        s << " #{self.title}"
      end
      s << " #{self.firstname} #{self.lastname}"
    end

    def company_name(billing=true)
      if billing == true && self.billing_company_id.present? && self.billing_company.title.present?
        company = GoldencobraEvents::Company.where(id: self.billing_company_id).first
        if company && company.title != "privat Person"
          result = company.title
        end
      elsif self.company_id.present?
        company = GoldencobraEvents::Company.where(id: self.company_id).first
        if company && company.title != "privat Person"
          result = company.title
        end
      else
        result = nil
      end
      result
    end

    def total_price
      total_price = 0
      self.event_registrations.each do |e|
        total_price += e.event_pricegroup.price if e.event_pricegroup && e.event_pricegroup.price
      end
      return total_price
    end


    def pricegroup_title
      master_reg = master_event_registration
      if master_reg && master_reg.event_pricegroup.present? && master_reg.event_pricegroup.pricegroup.present? && master_reg.event_pricegroup.pricegroup.title.present?
        master_reg.event_pricegroup.pricegroup.title
      else
        "leer"
      end
    end

    def master_event_registration
      self.event_registrations.where("goldencobra_events_events.ancestry IS NULL").joins(:event_pricegroup => :event).first
    end


    def registration_emails
      self.vita_steps.where(title: "Mail delivered: registration confirmation")
    end

    def last_email_send
      emails = self.registration_emails
      if emails.any?
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
        company = GoldencobraEvents::Company.new if self.company_id.blank?
        company.location = Goldencobra::Location.new if company.present? && company.location.blank?
        self.company = company
        self.save
      end
    end

    def self.create_from_master_data(user_id)
      user = User.find(user_id)
      if user
        GoldencobraEvents::RegistrationUser.create(email: user.email,
                                                   firstname: user.firstname,
                                                   lastname: user.lastname,
                                                   gender: user.gender,
                                                   title: user.title,
                                                   phone: user.phone,
                                                   function: user.function,
                                                   company_id: user.company_id,
                                                   type_of_registration: "",
                                                   comment: "Anmeldung aus Stammdaten erzeugt",
                                                   user_id: user.id)
      end
    end

    def check_for_master_data
      if self.email.present?
        # Set user_id from existing User
        new_user = User.where(email: self.email).first_or_create do |user|
          user.firstname = self.firstname
          user.lastname = self.lastname
          user.title = self.title
          user.gender = self.gender
          password = Devise.friendly_token
          user.password = password
          user.password_confirmation = password
        end
        if self.user_id != new_user.id
          self.update_attributes(user_id: new_user.id)
        end
      end
    end

    def self.search_with_indifferent_attributes(input)
      if input.present?
        company_ids = GoldencobraEvents::Company.where("goldencobra_events_companies.title LIKE '%#{input}%'").pluck(:id)
        GoldencobraEvents::RegistrationUser.where("goldencobra_events_registration_users.email LIKE '%#{input}%' OR goldencobra_events_registration_users.lastname LIKE '%#{input}%' OR goldencobra_events_registration_users.firstname LIKE '%#{input}%' OR goldencobra_events_registration_users.company_id IN (?)", company_ids)
      end
    end
  end
end

