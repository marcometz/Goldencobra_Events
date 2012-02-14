require "devise"
User.class_eval do
  has_many :event_registrations, class_name: GoldencobraEvents::EventRegistration
end
                            

Goldencobra::ArticlesHelper.module_eval do
  
  def render_registration_basket()
      render :partial => "goldencobra_events/events/registration_basket"
  end
  
end
