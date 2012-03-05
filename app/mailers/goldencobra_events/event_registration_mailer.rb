module GoldencobraEvents
  class EventRegistrationMailer < ActionMailer::Base
    default from: "cloudforum@tagesspiegel.de"
    default subject: "Anmeldebestaetigung Cloud Forum 2012"
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
