# == Schema Information
#
# Table name: goldencobra_events_events
#
#  id                          :integer(4)      not null, primary key
#  ancestry                    :string(255)
#  title                       :string(255)
#  description                 :text
#  created_at                  :datetime        not null
#  updated_at                  :datetime        not null
#  active                      :boolean(1)      default(TRUE)
#  external_link               :string(255)
#  max_number_of_participators :integer(4)      default(0)
#  type_of_event               :string(255)
#  type_of_registration        :string(255)
#  exclusive                   :boolean(1)      default(FALSE)
#

module GoldencobraEvents
  class Event < ActiveRecord::Base
    has_ancestry :orphan_strategy => :restrict
  end
end
