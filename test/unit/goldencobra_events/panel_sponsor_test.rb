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

require 'test_helper'

module GoldencobraEvents
  class PanelSponsorTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
