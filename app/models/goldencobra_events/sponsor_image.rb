# == Schema Information
#
# Table name: goldencobra_events_sponsor_images
#
#  id         :integer          not null, primary key
#  sponsor_id :integer
#  image_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module GoldencobraEvents
  class SponsorImage < ActiveRecord::Base
    
    belongs_to :sponsor
    belongs_to :image, :class_name => Goldencobra::Upload, :foreign_key => "image_id"
    
  end
end
