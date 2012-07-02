require 'test_helper'

module GoldencobraEvents
  class RegistrationUserTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end
  end
end

# == Schema Information
#
# Table name: goldencobra_events_registration_users
#
#  id                      :integer(4)      not null, primary key
#  user_id                 :integer(4)
#  gender                  :boolean(1)
#  email                   :string(255)
#  title                   :string(255)
#  firstname               :string(255)
#  lastname                :string(255)
#  function                :string(255)
#  phone                   :string(255)
#  agb                     :boolean(1)
#  company_id              :integer(4)
#  created_at              :datetime        not null
#  updated_at              :datetime        not null
#  type_of_registration    :string(255)     default("Webseite")
#  comment                 :text
#  invoice_sent            :datetime
#  payed_on                :datetime
#  first_reminder_sent     :datetime
#  second_reminder_sent    :datetime
#  active                  :boolean(1)      default(TRUE)
#  delivery_gender         :boolean(1)
#  delivery_title          :string(255)
#  delivery_firstname      :string(255)
#  delivery_lastname       :string(255)
#  delivery_function       :string(255)
#  delivery_phone          :string(255)
#  delivery_company_id     :integer(4)
#  delivery_contact_person :string(255)
#  delivery_department     :string(255)
#

