module GoldencobraEvents
  class Bouncer
    class << self
      def check_bounce_status
        require 'net/imap.rb'
        require 'mail'

        # Connect with imap account and iterate all undeleted messages
        # Check messages for response codes
        imap = Net::IMAP.new(Goldencobra::Setting.for_key('goldencobra_events.imap.domain'))
        imap.authenticate('LOGIN',Goldencobra::Setting.for_key('goldencobra_events.imap.login'),Goldencobra::Setting.for_key('goldencobra_events.imap.password'))
        imap.select('INBOX')
        bounce_results = []
        counter = 0
        imap.search(["NOT", "DELETED"]).each do |message_id|
          # Use gem 'mail' to check for mail status
          mail = Mail::Message.new(imap.fetch(message_id, "RFC822")[0].attr["RFC822"])
          if mail.bounced?
            counter += 1
            # puts "#{mail.final_recipient.split("rfc822;")[1]} bounced, status: #{mail.error_status}, retryable: #{mail.retryable?}"
            address = mail.final_recipient.split("rfc822;")[1]
            blacklist_entry = GoldencobraEvents::EmailBlacklist.find_by_email_address(address) || GoldencobraEvents::EmailBlacklist.new(email_address: address)
            if blacklist_entry.count
              blacklist_entry.count += 1
            else
              blacklist_entry.count = 1
            end
            blacklist_entry.retryable = mail.retryable?
            blacklist_entry.status_code = mail.error_status
            blacklist_entry.save
          end
          # delete message after parsing
          # imap.store(message_id, "+FLAGS", [:Deleted])
        end

        # Send bounce report
        if Goldencobra::Setting.for_key('goldencobra_events.imap.send_bounce_report') == 'true'
          GoldencobraEvents::BouncerMailer.report_bouncing(Goldencobra::Setting.for_key('goldencobra_events.imap.bounce_recipient'), counter).deliver
        end
      end
    end
  end
end