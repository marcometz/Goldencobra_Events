ActiveAdmin.setup do |config|
  unless Rails.env == "production"
    config.load_paths << "#{GoldencobraEvents::Engine.root}/app/admin/"
  end
  config.load_paths << "#{Goldencobra::Engine.root}/app/admin/"
  config.register_stylesheet 'goldencobra_events/active_admin'
end
