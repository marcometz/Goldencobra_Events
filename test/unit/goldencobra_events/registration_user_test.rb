# == Schema Information
#
# Table name: goldencobra_events_registration_users
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  gender     :boolean(1)
#  email      :string(255)
#  title      :string(255)
#  firstname  :string(255)
#  lastname   :string(255)
#  function   :string(255)
#  phone      :string(255)
#  agb        :boolean(1)
#  company_id :integer(4)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'test_helper'

module GoldencobraEvents
  class RegistrationUserTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end
