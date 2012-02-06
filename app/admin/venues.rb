ActiveAdmin.register GoldencobraEvents::Venue, :as => "Venue" do
  
  menu :parent => "Event-Management"
  
  form :html => { :enctype => "multipart/form-data" }  do |f|
    f.inputs "Allgemein" do
      f.input :title, :hint => "Der Titel der Seite, kann Leerzeichen und Sonderzeichen enthalten"
      f.input :description
      f.input :link_url
      f.input :phone
      f.input :email
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