Rails.application.config.to_prepare do
  require "devise"
  User.class_eval do
    scope :event_applicants, joins(:roles).where("goldencobra_roles.name = 'EventRegistrations'")
    has_many :registration_users, class_name: GoldencobraEvents::RegistrationUser#, :foreign_key => "user_id"
    belongs_to :company, :class_name => GoldencobraEvents::Company
    attr_accessible :company_id, :newsletter
  end
end
