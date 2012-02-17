module GoldencobraEvents
  class EventsController < ApplicationController
    
    around_filter :init_registration_session, :only => [:register, :cancel, :perform_registration]
    
    def register
      @event_to_register = GoldencobraEvents::Event.find_by_id(params[:id])
      if (params[:event] && params[:event][:event_pricegroup] && params[:event][:event_pricegroup].present?) || @event_to_register.event_pricegroups.count == 1
        if params[:event] && params[:event][:event_pricegroup] && params[:event][:event_pricegroup].present?
          epg_id = params[:event][:event_pricegroup]
        else
          epg_id = @event_to_register.event_pricegroups.first.id
        end
        @registered_event_price_group = GoldencobraEvents::EventPricegroup.find_by_id(epg_id)
        event_registration = GoldencobraEvents::EventRegistration.new(:event_pricegroup => @registered_event_price_group)
        if true #event_registration.registerable?(session[:goldencobra_event_registration][:pricegroup_ids] )
          session[:goldencobra_event_registration][:pricegroup_ids] << @registered_event_price_group.id
        end
      end
    end
    
    def cancel
      @eventpricegroup_to_cancel = GoldencobraEvents::EventPricegroup.find_by_id(params[:id])
      @events_removed = false
      event_registration = GoldencobraEvents::EventRegistration.new(:event_pricegroup => @eventpricegroup_to_cancel)
      if true #event_registration.cancelable?(session[:goldencobra_event_registration][:pricegroup_ids])
        @event_pricegroup_ids_to_cancel = @eventpricegroup_to_cancel.event.subtree.map(&:event_pricegroup_ids).flatten.compact
        if @event_pricegroup_ids_to_cancel && @event_pricegroup_ids_to_cancel.count > 0
          session[:goldencobra_event_registration][:pricegroup_ids] = session[:goldencobra_event_registration][:pricegroup_ids].delete_if{|a| @event_pricegroup_ids_to_cancel.include?(a) }
          @events_removed = true
        else
          raise "list of event_pricegroup_ids_to_cancel is empty"
        end
      end
    end
    
    
    def perform_registration
      @errors = []
      @result = nil
      @errors << "no_events_selected" if session[:goldencobra_event_registration][:pricegroup_ids].blank?
      @errors << "no_user_selected" if session[:goldencobra_event_registration][:user_id].blank? && params[:registration].blank?
      if params[:registration] && params[:registration].present? && params[:registration][:user] && params[:registration][:user].present?
          user = User.create(params[:registration][:user])
          user.roles << Role.find_by_name("EventRegistrations")
          if user.present? && user.id.present?
              session[:goldencobra_event_registration][:user_id] = user.id
          else
              session[:goldencobra_event_registration][:user_id] = nil
              @errors << user.errors.messages
              @errors << "user_invalid"
          end
      end
      if @errors.blank? && session[:goldencobra_event_registration][:user_id].present? && session[:goldencobra_event_registration].present? && session[:goldencobra_event_registration][:pricegroup_ids].present?
        user = User.find_by_id(session[:goldencobra_event_registration][:user_id])
        if user.present?
          @result = GoldencobraEvents::EventRegistration.create_batch(session[:goldencobra_event_registration][:pricegroup_ids], user)
          @errors << @result if @result != true
        else
          @errors << "user_not_exists"
        end
      end
    end
    
    
    private
    def init_registration_session
      session[:goldencobra_event_registration] = {} if session[:goldencobra_event_registration].blank?
      session[:goldencobra_event_registration][:pricegroup_ids] = [] if session[:goldencobra_event_registration][:pricegroup_ids].blank?  
      if session[:goldencobra_event_registration].present? && session[:goldencobra_event_registration][:user_id].present?
        @current_user = User.find_by_id(session[:goldencobra_event_registration][:user_id])
        if @current_user && @current_user.event_registrations.count > 0
          @already_registered_ids = @current_user.event_registrations.map(&:event_pricegroup_id)
          session[:goldencobra_event_registration][:pricegroup_ids] << @already_registered_ids
          session[:goldencobra_event_registration][:pricegroup_ids] = session[:goldencobra_event_registration][:pricegroup_ids].flatten.uniq.compact
        end
      end
      yield
      session[:goldencobra_event_registration][:pricegroup_ids] = session[:goldencobra_event_registration][:pricegroup_ids].uniq.compact
    end
    
  end
end
