ActiveAdmin.setup do |config|
  if !config.load_paths.include?("#{GoldencobraEvents::Engine.root}/app/admin/")
    config.load_paths << "#{GoldencobraEvents::Engine.root}/app/admin/"
  end
  config.register_stylesheet 'goldencobra_events/active_admin'
end
