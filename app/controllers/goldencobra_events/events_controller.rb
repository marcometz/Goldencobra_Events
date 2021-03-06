  module GoldencobraEvents
  class EventsController < ApplicationController

    around_filter :init_registration_session, :only => [:register]#, :cancel, :perform_registration]

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


# PW am 18.04.: Meiner Meinung ist das hier überflüssig und falsch, die Variable @valid_webcode wurde nur einmal verwendet, da nehmen wir jetzt auch @webcode
#    def validate_web_code
#      if params[:webcode] && params[:webcode].present?
#        session[:goldencobra_events_webcode] = params[:webcode]
#        @webcode = true
#        if GoldencobraEvents::EventPricegroup.select(:webcode).map(&:webcode).include?(params[:webcode])
#          @valid_webcode = true
#        else
#         @valid_webcode = false
#        end
#      end
#    end


    def display_agb
      art_id = Goldencobra::Setting.find_by_title("agb_article_id")
      if art_id.present? && art_id.value != "0"
        @agb = Goldencobra::Article.find_by_id(art_id.value)
      end
    end

    def register
      @webcode = false
      @article = Goldencobra::Article.find(params[:article_id]) if params[:article_id] && params[:article_id].present?
      validate_web_code()

      if params[:id] && params[:id].present?
        @event_to_register = GoldencobraEvents::Event.find_by_id(params[:id])
        #Wenn eine Eventoption gebucht wird....
        if (params[:event] && params[:event][:event_pricegroup] && params[:event][:event_pricegroup].present?) || @event_to_register.event_pricegroups.count == 1
          @registered_event_price_group = get_event_pricegroup()
          #neue Wahl durch radio_button => event ist exklusiv und alle seine (evt.) bisher registrierten Geschwister müssen entfernt werden
          if @registered_event_price_group.event.parent && @registered_event_price_group.event.parent.exclusive == true
            remove_existing_registrations_from_session_if_needed()
          end

          #prüfe ob bestehenden registrierungskombinationen valide sind => Fehler in @errors speichern bzw. ergebnis in session
          event_registration = GoldencobraEvents::EventRegistration.new(:event_pricegroup => @registered_event_price_group)
          check = event_registration.is_registerable?(session[:goldencobra_event_registration][:pricegroup_ids] )
          if check
            session[:goldencobra_event_registration][:pricegroup_ids] << @registered_event_price_group.id
            session[:goldencobra_event_registration][:price] = @registered_event_price_group.price
          else
            @errors = check
          end
        end
      end
    end

    def summary
      @errors = []
      @result = nil
      @errors << "no_events_selected" if session[:goldencobra_event_registration][:pricegroup_ids].blank?
      @errors << "no_user_selected" if params[:registration][:user].blank? && params[:registration].blank?
      @errors << "agb can't be blank" unless params[:AGB][:accepted] && params[:AGB][:accepted].present? && params[:AGB][:accepted] == "1"
      unless params[:registration][:user][:email].to_s =~ /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/
        params[:registration][:user] = ""
        @errors << "email wrong"
      end

      unless params[:registration][:company][:location_attributes][:zip].to_s =~ /^\d{5}$/
        params[:registration][:company] = ""
        @errors << "zip wrong"
      end

      # Wenn alternative Rechnungsadresse angegeben ist, muessen Pflichtfelder
      # ausgefuellt sein
      if params[:registration][:billing].present? && params[:registration][:billing][:choice].present? && params[:registration][:billing][:choice].any? && params[:registration][:billing][:choice][0] == "true"
        if params[:registration][:billing_user][:billing_gender].present? && params[:registration][:billing_user][:billing_lastname].present? &&
           params[:registration][:billing_company][:location_attributes][:street].present? &&
           params[:registration][:billing_company][:location_attributes][:zip].present? &&
           params[:registration][:billing_company][:location_attributes][:city].present?
        else
          @errors << params[:registration][:billing][:choice][0].to_s
        end
      end

      if params[:registration] && params[:registration].present? && params[:registration][:user] &&
         params[:registration][:user].present? && params[:AGB][:accepted] && params[:AGB][:accepted].present? &&
         params[:AGB][:accepted] == "1"

        #save user data in session
        session[:goldencobra_event_registration][:user_data] = params[:registration][:user]
        # session[:goldencobra_event_registration][:user_data]["should_not_initialize"] = true
        @summary_user = GoldencobraEvents::RegistrationUser.new(session[:goldencobra_event_registration][:user_data], "should_not_initialize" => true)
        if params[:registration][:company].present?
          session[:goldencobra_event_registration][:user_company_data] =  params[:registration][:company]
          if session[:goldencobra_event_registration][:user_company_data][:title].blank?
            session[:goldencobra_event_registration][:user_company_data][:title] = "privat Person"
          end
          @summary_company = GoldencobraEvents::Company.new(session[:goldencobra_event_registration][:user_company_data])
        end

        # alternate billing address present?
        if params[:registration][:billing].present? && params[:registration][:billing][:choice].present? && params[:registration][:billing][:choice][0] == "true" &&
           params[:registration][:billing_user] && params[:registration][:billing_user].present?

          session[:goldencobra_event_registration][:billing_user_data] = params[:registration][:billing_user]
          @summary_user.billing_gender = params[:registration][:billing_user][:billing_gender]
          @summary_user.billing_firstname = params[:registration][:billing_user][:billing_firstname]
          @summary_user.billing_lastname = params[:registration][:billing_user][:billing_lastname]
          @summary_user.billing_department = params[:registration][:billing_user][:billing_department]

          if params[:registration][:billing_company].present?
            session[:goldencobra_event_registration][:user_billing_company_data] =  params[:registration][:billing_company]
            if session[:goldencobra_event_registration][:user_billing_company_data][:title].blank?
              session[:goldencobra_event_registration][:user_billing_company_data][:title] = "privat Person"
            end
            @billing_company = GoldencobraEvents::Company.new(session[:goldencobra_event_registration][:user_billing_company_data])
          end
        end
      else
        @errors << "agb not accepted"
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
      if session[:goldencobra_event_registration].present? && session[:goldencobra_event_registration][:user_data].present? && session[:goldencobra_event_registration][:pricegroup_ids].present?

        # Create user
        reguser = GoldencobraEvents::RegistrationUser.create(session[:goldencobra_event_registration][:user_data])
        reguser.update_attributes(session[:goldencobra_event_registration][:billing_user_data])
        user = User.find_by_email(reguser.email)
        unless user
          generated_password = Devise.friendly_token.first(6)
          user = User.create(:email => reguser.email, :password => generated_password, :password_confirmation => generated_password, :firstname => reguser.firstname, :lastname => reguser.lastname, :title => reguser.title)
          # Add default user Role für event Registrators
          user.roles << Goldencobra::Role.find_or_create_by_name("EventRegistrations")
        end
        reguser.user = user
        reguser.save

        # Add Company to user if data provided
        if reguser && session[:goldencobra_event_registration][:user_company_data].present?
          company = GoldencobraEvents::Company.create(session[:goldencobra_event_registration][:user_company_data])
          if company.present? && company.id.present?
            reguser.company = company
          end
          if session[:goldencobra_event_registration][:user_billing_company_data].present?
            billing_company = GoldencobraEvents::Company.create(session[:goldencobra_event_registration][:user_billing_company_data])
            reguser.billing_company_id = billing_company.id
          end
          reguser.save
        end

        if reguser.present? && reguser.id.present?
            session[:goldencobra_event_registration][:user_id] = reguser.id
            @result = GoldencobraEvents::EventRegistration.create_batch(session[:goldencobra_event_registration][:pricegroup_ids], reguser)
            @errors << @result if @result != true
            if @result == true
              # Ticket generieren, da es direkt mit der Bestätigungsmail versandt wird
              if reguser.event_registrations.any? && reguser.master_event_registration.ticket_number.blank?
                GoldencobraEvents::Ticket.generate_ticket(reguser.master_event_registration)
              end
              GoldencobraEvents::EventRegistrationMailer.registration_email(reguser).deliver unless Rails.env == "test"
              reguser.vita_steps << Goldencobra::Vita.create(:title => "Mail delivered: registration confirmation", :description => "email: #{reguser.email}, user: customer #{reguser.id}")
              reguser.user.vita_steps << Goldencobra::Vita.create(:title => "Mail delivered: registration confirmation", :description => "email: #{reguser.email}, user: customer #{reguser.id}") if reguser.user.present?
          end
            reset_session
        else
          @errors << "user_not_exists"
        end
      end
    end

    private

    def remove_existing_registrations_from_session_if_needed
      siblings_ids = []
      @registered_event_price_group.event.siblings.each do |sibling|
        siblings_ids << GoldencobraEvents::EventPricegroup.find_by_event_id(sibling.id).id
      end
      session[:goldencobra_event_registration][:pricegroup_ids] -= siblings_ids
    end

    def get_event_pricegroup
      if params[:event] && params[:event][:event_pricegroup] && params[:event][:event_pricegroup].present?
        epg_id = params[:event][:event_pricegroup]
      else
        epg_id = @event_to_register.event_pricegroups.first.id
      end
      return GoldencobraEvents::EventPricegroup.find_by_id(epg_id)
    end

    def init_registration_session
      session[:goldencobra_event_registration] = {} if session[:goldencobra_event_registration].blank?
      session[:goldencobra_event_registration][:pricegroup_ids] = [] if session[:goldencobra_event_registration][:pricegroup_ids].blank?
      session[:goldencobra_event_registration][:price] = nil
      if session[:goldencobra_event_registration].present? && session[:goldencobra_event_registration][:user_id].present?
        @current_user = User.find_by_id(session[:goldencobra_event_registration][:user_id])
        if @current_user && @current_user.event_registrations.count > 0
          @already_registered_ids = @current_user.event_registrations.map(&:event_pricegroup_id)
          session[:goldencobra_event_registration][:pricegroup_ids] << @already_registered_ids
          session[:goldencobra_event_registration][:pricegroup_ids] = session[:goldencobra_event_registration][:pricegroup_ids].flatten.uniq.compact
        end
      end
      yield
    end
  end
end
