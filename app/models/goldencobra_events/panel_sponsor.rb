# == Schema Information
#
# Table name: goldencobra_events_panel_sponsors
#
#  id         :integer          not null, primary key
#  panel_id   :integer
#  sponsor_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module GoldencobraEvents
  class PanelSponsor < ActiveRecord::Base
    belongs_to :panel
    belongs_to :sponsor
  end
end
