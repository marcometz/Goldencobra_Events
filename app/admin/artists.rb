ActiveAdmin.register GoldencobraEvents::Artist, :as => "Artist" do
  menu :parent => "Event-Management", :label => "Kuenstler"

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs "Allgemein" do
      f.input :title, :hint => "Required"
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
    f.inputs "" do
      f.has_many :artist_images do |ai|
        ai.input :image, :as => :select, :collection => Goldencobra::Upload.all.map{|c| [c.complete_list_name, c.id]}, :input_html => { :class => 'artist_image_file'} 
      end
    end
    f.inputs "Informationen" do
      f.input :sponsors, :as => :check_boxes, :collection => GoldencobraEvents::Sponsor.find(:all, :order => "title ASC")
    end
    f.buttons
  end

  action_item :only => :show do
    link_to('New Artist', new_admin_artist_path)
  end

  show :title => :title do
    panel "Artist" do
      attributes_table_for artist do
        [:title, :description, :url_link, :email, :telephone, :created_at, :updated_at].each do |aa|
          row aa
        end
      end
    end #end panel artist
    panel "Sponsors" do
      table do
        tr do
          ["Title", "Description", "Homepage", "Size of Sponsorship", "Telephone", "Email"].each do |sa|
            th sa
          end
        end
        artist.sponsors.each do |as|
          tr do
            [as.title, as.description, as.size_of_sponsorship, as.type_of_sponsorship].each do |esa|
              td esa
            end
          end
        end

      end
    end #end panel sponsors
  end

end
