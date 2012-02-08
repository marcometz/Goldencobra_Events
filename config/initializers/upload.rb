Goldencobra::Upload.class_eval do
  has_many :sponsor_images, :class_name => GoldencobraEvents::SponsorImage
  has_many :sponsors, :through => :sponsor_images
end
