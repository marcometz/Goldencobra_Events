module GoldencobraEvents
  class Venue < ActiveRecord::Base
    
    belongs_to :location, :class_name => Goldencobra::Location
    accepts_nested_attributes_for :location
  end
end
