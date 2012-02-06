Goldencobra::Location.class_eval do
  has_many :venues, :class_name => GoldencobraEvents::Venue
  accepts_nested_attributes_for :venues
end
