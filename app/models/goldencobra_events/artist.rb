# == Schema Information
#
# Table name: goldencobra_events_artists
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)
#  description :string(255)
#  url_link    :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  telephone   :string(255)
#  email       :string(255)
#  location_id :integer(4)
#

module GoldencobraEvents
  class Artist < ActiveRecord::Base
    belongs_to :location, :class_name => Goldencobra::Location
    accepts_nested_attributes_for :location
  end
end
