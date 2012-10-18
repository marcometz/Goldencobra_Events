module GoldencobraEvents
  class BouncerMailer < ActionMailer::Base
    default from: Goldencobra::Setting.for_key("goldencobra_events.imap.bouncer_mailer.from")
    default subject: Goldencobra::Setting.for_key("goldencobra_events.imap.bouncer_mailer.subject")
    default :content_type => "text/html"
    default :reply_to => Goldencobra::Setting.for_key("goldencobra_events.imap.bouncer_mailer.reply_to")

    def report_bouncing(email = nil, counter = 0)
      @counter = counter
      @url = Goldencobra::Setting.for_key('goldencobra.url')
      if email.present?
        mail to:email, bcc: 'holger@ikusei.de'
      else
        logger.error 'BouncerMailer needs an email to send report.'
        do_not_deliver!
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
