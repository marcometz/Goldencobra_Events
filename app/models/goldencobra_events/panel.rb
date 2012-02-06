module GoldencobraEvents
  class Panel < ActiveRecord::Base
    has_many :events
  end
end
