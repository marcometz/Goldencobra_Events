ActiveAdmin.setup do |config|
  config.load_paths << "#{Goldencobra::Engine.root}/app/admin/"
  config.load_paths << "#{GoldencobraEvents::Engine.root}/app/admin/"
  config.load_paths = config.load_paths.uniq
  config.register_stylesheet 'goldencobra_events/active_admin'
end
