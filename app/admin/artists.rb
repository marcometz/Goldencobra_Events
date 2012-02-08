ActiveAdmin.register GoldencobraEvents::Artist, :as => "Artist" do
  menu :parent => "Event-Management"

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs "Allgemein" do
      f.input :title
      f.input :description
      f.input :url_link, :label => "Homepage Link"
      f.input :email
      f.input :telephone
    end
    f.inputs "" do
      f.fields_for :location_attributes, f.object.location do |loc|
        loc.inputs "LocationAttributes" do
          loc.input :street
          loc.input :city
          loc.input :zip
          loc.input :region
          loc.input :country, :as => :string
          loc.input :lat
          loc.input :lng
        end
      end
    end
    f.buttons
  end

end
