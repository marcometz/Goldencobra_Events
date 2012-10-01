ActiveAdmin.register GoldencobraEvents::Artist, :as => "Artist" do
  menu :parent => "Event-Management", :if => proc{false}#can?(:read, GoldencobraEvents::Artist) && (Goldencobra::Setting.for_key('goldencobra_events.active_admin.menue.artists.display') != "false")}
  controller.authorize_resource :class => GoldencobraEvents::Artist

  filter :title, :label => "Name"
  filter :email, :label => "E-Mail"
  filter :description, :label => "Beschreibung"

  index do
    column :title, :sortable => :title do |artist|
      artist.title
    end
    column :description do |artist|
      artist.description
    end
    column :email, sortable: :email do |artist|
      artist.email
    end
    column :url_link, :sortable => :url_link do |artist|
      artist.url_link
    end
    column :telephone, sortable: :telephone do |artist|
      artist.telephone
    end
    default_actions
  end

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs :class => "buttons inputs" do
      f.actions
    end
    f.inputs "Allgemein" do
      f.input :title, :hint => "Muss ausgefuellt werden"
      f.input :description, :input_html => { :class =>"tinymce"}
      f.input :url_link, :label => "Homepage Link"
      f.input :email
      f.input :telephone
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
    f.inputs "Bilder" do
      f.has_many :artist_images do |ai|
        ai.input :image, :as => :select, :collection => Goldencobra::Upload.all.map{|c| [c.complete_list_name, c.id]}, :input_html => { :class => 'artist_image_file'}
      end
    end
    f.inputs "Informationen" do
      f.input :sponsors, as: :check_boxes, :collection => GoldencobraEvents::Sponsor.find(:all, :order => "title ASC").map{|c| [c.title, c.id]}, :input_html => { "multiple" => "multiple"}
    end
    f.inputs :class => "buttons inputs" do
      f.actions
    end
  end

  action_item :only => :show do
    link_to(t('active_admin.artist.new_artist'), new_admin_artist_path)
  end

  batch_action :destroy, false

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
