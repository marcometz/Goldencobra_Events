# == Schema Information
#
# Table name: goldencobra_events_panels
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)
#  description :text
#  link_url    :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

module GoldencobraEvents
  class Panel < ActiveRecord::Base
    has_many :events
    has_many :panel_sponsors
    has_many :sponsors, :through => :panel_sponsors
  end
end
