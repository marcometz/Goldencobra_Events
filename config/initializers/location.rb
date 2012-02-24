Rails.application.config.to_prepare do
  Goldencobra::Location.class_eval do
    has_many :venues, :class_name => GoldencobraEvents::Venue
    accepts_nested_attributes_for :venues
    has_many :companies, :class_name => GoldencobraEvents::Company
    accepts_nested_attributes_for :companies
  end
end
