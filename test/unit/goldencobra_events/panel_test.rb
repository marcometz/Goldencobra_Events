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

require 'test_helper'

module GoldencobraEvents
  class PanelTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
