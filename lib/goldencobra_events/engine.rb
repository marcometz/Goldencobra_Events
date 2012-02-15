module GoldencobraEvents
  class Engine < ::Rails::Engine
    isolate_namespace GoldencobraEvents
    config.to_prepare do
      ApplicationController.helper(GoldencobraEvents::EventsHelper)
      ApplicationController.helper(GoldencobraEvents::ApplicationHelper)      
    end
  end
end
