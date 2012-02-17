require "devise"
User.class_eval do
  scope :event_applicants, User.joins(:roles).where("goldencobra_roles.name = 'event_registration'")
  has_many :event_registrations, class_name: GoldencobraEvents::EventRegistration
  belongs_to :company, :class_name => GoldencobraEvents::Company
  
  def total_price
    total_price = 0
    self.event_registrations.each do |e|
      total_price += e.event_pricegroup.price
    end
    return total_price
  end
end
