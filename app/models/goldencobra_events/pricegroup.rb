# == Schema Information
#
# Table name: goldencobra_events_pricegroups
#
#  id         :integer(4)      not null, primary key
#  title      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

module GoldencobraEvents
  class Pricegroup < ActiveRecord::Base
    has_many :event_pricegroups
    has_many :events, :through => :event_pricegroups
  end
end
