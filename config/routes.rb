GoldencobraEvents::Engine.routes.draw do
  get "events/register"

  match 'event/:id/register' => 'events#register', :as => :register_event
  match 'event/:id/cancel' => 'events#cancel', :as => :cancel_event
end
