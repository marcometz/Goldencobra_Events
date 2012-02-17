module GoldencobraEvents
  class Company < ActiveRecord::Base
    has_many :users, :class_name => User
    belongs_to :location, :class_name => Goldencobra::Location
    accepts_nested_attributes_for :location

  end
end
