Rails.application.config.to_prepare do
  Goldencobra::Article.class_eval do
    belongs_to :event, class_name: GoldencobraEvents::Event, foreign_key: "event_id"
  end
end