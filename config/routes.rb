GoldencobraEvents::Engine.routes.draw do
  get "events/register"

  match 'event/:id/register' => 'events#register', :as => :register_event
  match 'event/:id/cancel' => 'events#cancel', :as => :cancel_event
  match 'events/registration' => 'events#perform_registration', :as => :perform_events_registration
  
end
