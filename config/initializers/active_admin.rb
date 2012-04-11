unless Rails.env == "production"
  ActiveAdmin.setup do |config|
    config.load_paths << "#{Goldencobra::Engine.root}/app/admin/"
    config.load_paths << "#{GoldencobraEvents::Engine.root}/app/admin/"
    config.load_paths = config.load_paths.uniq
    config.register_stylesheet 'goldencobra_events/active_admin'
  end
end
# ActiveAdmin.unload!
# ActiveAdmin.application.load_paths <<"#{GoldencobraEvents::Engine.root}/app/admin/"
# ActiveAdmin.application.load_paths << "#{Goldencobra::Engine.root}/app/admin/"
# ActiveAdmin.application.load_paths = ActiveAdmin.application.load_paths.uniq
# ActiveAdmin.load!
