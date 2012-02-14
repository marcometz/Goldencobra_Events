module GoldencobraEvents
  class EventsController < ApplicationController
    def register
      @event_to_register = GoldencobraEvents::Event.find_by_id(params[:id])
    end
  end
end
