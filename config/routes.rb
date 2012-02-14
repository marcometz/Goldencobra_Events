GoldencobraEvents::Engine.routes.draw do
  get "events/register"

  match 'event/:id/register' => 'events#register', :as => :register_event
end
