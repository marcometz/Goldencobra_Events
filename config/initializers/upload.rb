Goldencobra::Upload.class_eval do
  #this next 2 lines are for an image-gallery of sponsors
  has_many :sponsor_images, :class_name => GoldencobraEvents::SponsorImage
  has_many :sponsors, :through => :sponsor_images
  
  # this adds al logo-image to an sponsor 
  has_many :logo_sponsors, :class_name => GoldencobraEvents::Sponsor, :foreign_key => "logo_id"
end
