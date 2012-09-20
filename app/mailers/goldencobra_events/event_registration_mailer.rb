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
      if @user && @user.present? && GoldencobraEvents::EmailBlacklist.is_blacklisted?(user.email) == false
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
      subject = @email_template.subject.present? ? @email_template.subject : Goldencobra::Setting.for_key("goldencobra_events.event.registration.mailer.subject")
      @user = user
      if @user && @user.present? && GoldencobraEvents::EmailBlacklist.is_blacklisted?(user.email) == false
          mail to: user.email, bcc: "#{@email_template.bcc}", :css => "/goldencobra_events/email", :subject => subject
      end
    end


  end
end

# http://stackoverflow.com/questions/6550809/rails-3-how-to-abort-delivery-method-in-actionmailer

module ActionMailer
  class Base
    # A simple way to short circuit the delivery of an email from within
    # deliver_* methods defined in ActionMailer::Base subclases.
    def do_not_deliver!
      raise AbortDeliveryError
    end

    def process(*args)
      begin
        super *args
      rescue AbortDeliveryError
        self.message = BlackholeMailMessage
      end
    end
  end
end

class AbortDeliveryError < StandardError
end

class BlackholeMailMessage < Mail::Message
  def self.deliver
    false
  end
end
