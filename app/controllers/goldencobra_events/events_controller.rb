module GoldencobraEvents
  class EventsController < ApplicationController
    def register
      @event_to_register = GoldencobraEvents::Event.find_by_id(params[:id])
      if (params[:event] && params[:event][:event_pricegroup] && params[:event][:event_pricegroup].present?) || @event_to_register.event_pricegroups.count == 1
        
      end
    end
  end
end
