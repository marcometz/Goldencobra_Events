Rails.application.config.to_prepare do
  Goldencobra::Article.class_eval do
    belongs_to :event, class_name: GoldencobraEvents::Event, foreign_key: "event_id"
  end

  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.perform_deliveries = true

  ActionMailer::Base.smtp_settings = {
    address: "mail.ikusei.de",
    port: 25,
    domain: "ikusei.de",
    authentication: "plain",
    enable_starttls_auto: true,
    user_name: "holger+ikusei.de",
    password: "mVFtiO3dRKtV",
    enable_starttls_auto: false
  }
end