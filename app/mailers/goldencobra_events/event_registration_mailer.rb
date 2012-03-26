module GoldencobraEvents
  class EventRegistrationMailer < ActionMailer::Base
    default from: Goldencobra::Setting.for_key("goldencobra_events.event.registration.mailer.from") 
    default subject: Goldencobra::Setting.for_key("goldencobra_events.event.registration.mailer.subject") 
    default :content_type => "text/html"

    # Subject can be set in your I18n file at config/locales/en.yml
    # with the following lookup:
    #
    #   en.event_registration_mailer.registration.subject
    #
    def registration_email(user, email=nil)
      @user = user
      if @user && @user.present?
        if email != nil
          mail to: email, bcc: ['holger@ikusei.de']#, css: "http://cloudforum.tagesspiegel.de/assets/email.css"
        else
          mail to: user.email, bcc: ['holger@ikusei.de']#, css: "http://cloudforum.tagesspiegel.de/assets/email.css"
        end
      end
    end
  end
end
