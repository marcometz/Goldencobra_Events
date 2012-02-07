# == Schema Information
#
# Table name: goldencobra_events_panel_sponsors
#
#  id         :integer(4)      not null, primary key
#  panel_id   :integer(4)
#  sponsor_id :integer(4)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

module GoldencobraEvents
  class PanelSponsor < ActiveRecord::Base
    belongs_to :panel
    belongs_to :sponsor
  end
end
