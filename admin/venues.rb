ActiveAdmin.register GoldencobraEvents::Venue, :as => "Venue" do

  menu :parent => "Event-Management", :label => "Veranstaltungsorte", :if => proc{can?(:read, GoldencobraEvents::Venue)}
  controller.authorize_resource :class => GoldencobraEvents::Venue

  filter :title
  filter :link_url
  filter :email

  form :html => { :enctype => "multipart/form-data" }  do |f|
    f.inputs :class => "buttons inputs" do
      f.actions
    end
    f.inputs "Allgemein" do
      f.input :title, :hint => "Der Titel der Seite, kann Leerzeichen und Sonderzeichen enthalten"
      f.input :description
      f.input :link_url
      f.input :phone
      f.input :email
    end
    f.inputs "Adresse" do
      f.fields_for :location_attributes, f.object.location do |loc|
        loc.inputs "" do
          loc.input :street
          loc.input :city
          loc.input :zip
          loc.input :region
          loc.input :country, :as => :string
        end
      end
    end
    f.inputs :class => "buttons inputs" do
      f.actions
    end
  end

  action_item :only => :show do
    link_to('New Venue', new_admin_venue_path)
  end

  batch_action :destroy, false

  show :title => :title do
    panel "Venue Details" do
      attributes_table_for venue do
        row :title
        row :description
        row :phone
        row :email
        row :link_url
        row :created_at
        row :updated_at
      end
    end
    panel "Location" do
      attributes_table_for venue.location do
        row :street
        row :city
        row :zip
        row :region
        row :country
      end
    end
    active_admin_comments
  end
end
