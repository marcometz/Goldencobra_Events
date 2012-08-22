# == Schema Information
#
# Table name: goldencobra_events_companies
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  legal_form  :string(255)
#  location_id :integer
#  phone       :string(255)
#  fax         :string(255)
#  homepage    :string(255)
#  sector      :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

module GoldencobraEvents
  class Company < ActiveRecord::Base
    has_many :users, :class_name => GoldencobraEvents::RegistrationUser
    belongs_to :location, :class_name => Goldencobra::Location
    accepts_nested_attributes_for :location

  end
end
