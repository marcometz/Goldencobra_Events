module GoldencobraEvents
  class EmailBlacklist < ActiveRecord::Base
    class << self
      def is_blacklisted?(email)
        if Goldencobra::Setting.for_key('goldencobra_events.imap.use_blacklist') == "true"
          GoldencobraEvents::EmailBlacklist.where(email_address: email.to_s).any?
        else
          false
        end
      end
    end
  end
end
