# == Schema Information
#
# Table name: goldencobra_events_registration_users
#
#  id                   :integer(4)      not null, primary key
#  user_id              :integer(4)
#  gender               :boolean(1)
#  email                :string(255)
#  title                :string(255)
#  firstname            :string(255)
#  lastname             :string(255)
#  function             :string(255)
#  phone                :string(255)
#  agb                  :boolean(1)
#  company_id           :integer(4)
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#  type_of_registration :string(255)     default("Webseite")
#  comment              :text
#  invoice_sent         :datetime
#  payed_on             :datetime
#  first_reminder_sent  :datetime
#  second_reminder_sent :datetime
#

module GoldencobraEvents
  class RegistrationUser < ActiveRecord::Base
    has_many :event_registrations, class_name: GoldencobraEvents::EventRegistration, :foreign_key => "user_id"
    belongs_to :company, :class_name => GoldencobraEvents::Company
    belongs_to :user, :class_name => User
    has_many :vita_steps, :as => :loggable, :class_name => Goldencobra::Vita
    
    RegistrationTypes = ["Webseite", "Fax", "Email", "Telefon", "Importer", "Brieftaube", "anderer Weg"]
    
    accepts_nested_attributes_for :company
    accepts_nested_attributes_for :event_registrations, :allow_destroy => true
    liquid_methods :gender, :email, :title, :firstname, :lastname, :function, :anrede
        
    #scope :total_price_gt, lambda { |param| where(:field => "value") }
    #scope :total_price_eq, lambda { |param| where(:field => "value") }
    #scope :total_price_lt, lambda { |param| where(:field => "value") }    
    #    
    #search_methods :total_price_gt    
    #search_methods :total_price_lt
    #search_methods :total_price_eq
        
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
    
  end
end
