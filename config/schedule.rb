# Use gem 'whenever' to schedule a cron job to peridodically check for bounced emails in INBOX
every :day, :at => '01:00am' do
  if Goldencobra::Setting.for_key('goldencobra_events.imap.use_blacklist') == "true"
    runner "GoldencobraEvents::Bouncer.check_bounce_status"
  end
end