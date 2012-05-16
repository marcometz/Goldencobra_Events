require 'devise'
module GoldencobraEvents
  class Engine < ::Rails::Engine
    isolate_namespace GoldencobraEvents
    config.to_prepare do
      ApplicationController.helper(GoldencobraEvents::ApplicationHelper)      
      ActionController::Base.helper(GoldencobraEvents::ApplicationHelper)  
      DeviseController.helper(GoldencobraEvents::ApplicationHelper)           
      
      ApplicationController.helper(GoldencobraEvents::EventsHelper)
      ActionController::Base.helper(GoldencobraEvents::EventsHelper)     
      DeviseController.helper(GoldencobraEvents::EventsHelper)                    
    end
  end
end

