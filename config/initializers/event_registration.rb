Rails.application.config.to_prepare do
  require "devise"
  User.class_eval do
    scope :event_applicants, joins(:roles).where("goldencobra_roles.name = 'EventRegistrations'")
    has_many :event_registrations, class_name: GoldencobraEvents::EventRegistration
    belongs_to :company, :class_name => GoldencobraEvents::Company
    attr_accessible :company_id, :newsletter
    
    def total_price
      total_price = 0
      self.event_registrations.each do |e|
        total_price += e.event_pricegroup.price
      end
      return total_price
    end
  end
end
