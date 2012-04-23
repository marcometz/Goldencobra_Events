module GoldencobraEvents
  class EventRegistrationMailer < ActionMailer::Base
    default from: Goldencobra::Setting.for_key("goldencobra_events.event.registration.mailer.from") 
    default subject: Goldencobra::Setting.for_key("goldencobra_events.event.registration.mailer.subject") 
    default :content_type => "text/html"
    default :reply_to => Goldencobra::Setting.for_key("goldencobra_events.event.registration.mailer.reply_to") 

    # Subject can be set in your I18n file at config/locales/en.yml
    # with the following lookup:
    #
    #   en.event_registration_mailer.registration.subject
    #
    def registration_email(user, email=nil)
      @user = user
      if @user && @user.present?
        if email != nil
          mail to: email, bcc: ['holger@ikusei.de'], :css => "goldencobra_events/email"
        else
          mail to: user.email, bcc: ['holger@ikusei.de'], :css => "/goldencobra_events/email"
        end
      end
    end
    
    def registration_email_with_template(user, email_template)
      GoldencobraEvents::EventRegistration::LiquidParser["user"] = user
      @email_template = email_template
      @user = user
      if @user && @user.present?
          mail to: user.email, bcc: "#{@email_template.bcc}", :css => "/goldencobra_events/email"
      end
    end
    
    
  end
end
