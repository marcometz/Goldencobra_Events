require "devise"
User.class_eval do
  has_many :event_registrations, class_name: GoldencobraEvents::EventRegistration
end
