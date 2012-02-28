module GoldencobraEvents
  class EventsController < ApplicationController
    
    around_filter :init_registration_session, :only => [:register, :cancel, :perform_registration]
    
    def validate_webcode
      @webcode = false
      if params[:article_id] && params[:article_id].present?
        @article = Goldencobra::Article.find(params[:article_id])
      end
      if params[:webcode] && params[:webcode].present? && GoldencobraEvents::EventPricegroup.select(:webcode).map(&:webcode).include?(params[:webcode])
        session[:goldencobra_events_webcode] = params[:webcode] 
        @webcode = true
      end
    end
    
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
        check = event_registration.is_registerable?(session[:goldencobra_event_registration][:pricegroup_ids] )
        if check
          session[:goldencobra_event_registration][:pricegroup_ids] << @registered_event_price_group.id
        else
          @errors = check
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
        #Create or find user
        user = User.find_for_authentication(:email => params[:registration][:user][:email])
        if user == nil
          user = User.create(params[:registration][:user])
          #Add default user Role für event Registrators
          user.roles << Goldencobra::Role.find_or_create_by_name("EventRegistrations") if user
          #Add Company to user if data provided
          if user && params[:registration][:company].present?
            company = Company.create(params[:registration][:company])
            if company.present? && company.id.present?
              user.company = company
              user.save
            end
          end
        else
          user = user.valid_password?(params[:registration][:user][:password]) ? user : nil
        end
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
