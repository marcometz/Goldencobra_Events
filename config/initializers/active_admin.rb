ActiveAdmin.setup do |config|
  unless Rails.env == "production"
    config.load_paths << "#{GoldencobraEvents::Engine.root}/app/admin/"
  end
  config.register_stylesheet 'goldencobra_events/active_admin'
end
