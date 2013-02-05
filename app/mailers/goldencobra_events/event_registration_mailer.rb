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
        if email == nil
          email = @user.email
        end

        if user.event_registrations.any?
          ticket_number = user.event_registrations.last.ticket_number
          if Goldencobra::Setting.for_key('goldencobra_events.invoice.event_name_for_invoice').present?
            event_title = Goldencobra::Setting.for_key('goldencobra_events.invoice.event_name_for_invoice')
          end
          pricegroup_title = user.event_registrations.last.event_pricegroup.pricegroup.title if user.event_registrations.last.event_pricegroup.present? && user.event_registrations.last.event_pricegroup.pricegroup.present?
        end

        if ticket_number.present?
          attachments["Ticket-#{event_title}.pdf"] = File.read("#{Rails.root}/public/system/tickets/ticket_#{ticket_number}.pdf")
        end

        mail to: email, bcc: ['holger@ikusei.de'], :css => "goldencobra_events/email"
      end
    end

    def registration_email_with_template(user, email_template)
      GoldencobraEvents::EventRegistration::LiquidParser["user"] = user
      @email_template = email_template
      subject = @email_template.subject.present? ? @email_template.subject : Goldencobra::Setting.for_key("goldencobra_events.event.registration.mailer.subject")
      @user = user
      if @user && @user.present? && GoldencobraEvents::EmailBlacklist.is_blacklisted?(user.email) == false
          mail to: user.email, bcc: "#{@email_template.bcc}", :css => "/goldencobra_events/email", subject: subject
      end
    end

    def storno_email(registration_user_id)
      @user = GoldencobraEvents::RegistrationUser.find(registration_user_id)
      if @user
        mail to: Goldencobra::Setting.for_key('goldencobra_events.event.cancellation.info_email'), subject: I18n.t(:cancellation_info_subject, scope: [:active_admin, :applicants])
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
