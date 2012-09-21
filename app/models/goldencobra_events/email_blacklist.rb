# == Schema Information
#
# Table name: goldencobra_events_email_blacklists
#
#  id            :integer          not null, primary key
#  email_address :string(255)
#  status_code   :string(255)
#  retryable     :boolean
#  count         :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

module GoldencobraEvents
  class EmailBlacklist < ActiveRecord::Base
    def self.is_blacklisted?(email)
      if Goldencobra::Setting.for_key('goldencobra_events.imap.use_blacklist') == "true"
        GoldencobraEvents::EmailBlacklist.where(email_address: email.to_s).any?
      else
        false
      end
    end
  end
end
