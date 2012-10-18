# Use gem 'whenever' to schedule a cron job to peridodically check for bounced emails in INBOX
every :day, :at => '01:00am' do
  runner "GoldencobraEvents::Bouncer.check_bounce_status"
end