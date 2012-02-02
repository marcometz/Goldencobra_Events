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
#  start_date                  :datetime
#  end_date                    :datetime
#

module GoldencobraEvents
  class Event < ActiveRecord::Base
    has_ancestry :orphan_strategy => :restrict
    has_many :articles, :class_name => Goldencobra::Article   #, :foreign_key => "article_id"
    has_many :event_pricegroups
    has_many :pricegroups, :through => :event_pricegroups
    accepts_nested_attributes_for :event_pricegroups
    scope :active, where(:active => true)
    
  end
end
