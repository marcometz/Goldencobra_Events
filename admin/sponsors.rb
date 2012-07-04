ActiveAdmin.register GoldencobraEvents::Sponsor, :as => "Sponsor" do
  
  menu :parent => "Event-Management", :if => proc{can?(:read, GoldencobraEvents::Sponsor) && (Goldencobra::Setting.for_key('goldencobra_events.active_admin.menue.sponsors.display') != "false")}
  controller.authorize_resource :class => GoldencobraEvents::Sponsor
  
  filter :title
  filter :email
  filter :link_url
  
  batch_action :destroy, false
  
  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs :class => "buttons inputs" do
      f.actions
    end
    f.inputs "Allgemein" do
      f.input :title
      f.input :description, :input_html => { :class =>"tinymce"}
      f.input :link_url
      f.input :size_of_sponsorship, :as => :select, :collection => GoldencobraEvents::Sponsor::SponsorshipSize.map {|c| c}, :include_blank => false, :input_html => { :class => 'chzn-select'}
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
      f.input :logo, :as => :select, :collection => Goldencobra::Upload.all.map{|c| [c.complete_list_name, c.id]}, :input_html => { :class => 'sponsor_logo_image_file chzn-select'} 
      f.has_many :sponsor_images, label: "Test" do |si|
        si.input :image, :as => :select, :collection => Goldencobra::Upload.all.map{|c| [c.complete_list_name, c.id]}, :input_html => { :class => 'sponsor_image_file chzn-select'}
      end
    end
    f.inputs :class => "buttons inputs" do
      f.actions
    end
  end

  index do
    column :title, :sortable => :title do |sponsor|
      sponsor.title
    end
    column :email, sortable: :email do |sponsor|
      sponsor.email
    end
    column :link_url, :sortable => :link_url do |sponsor|
      sponsor.link_url
    end
    column :telephone, sortable: :telephone do |sponsor|
      sponsor.telephone
    end
    default_actions
  end

  action_item :only => :show do
    link_to(t(:new_sponsor, scope: [:active_admin]), new_admin_sponsor_path)
  end

  show :title => :title do
    panel "Sponsor Details" do
      attributes_table_for sponsor do
        row :title
        row :description
        row :link_url
        row :email
        row :telephone
        row :size_of_sponsorship
        row :type_of_sponsorship
        row :created_at
        row :updated_at
      end
    end
    panel "Location" do
      if sponsor.location.present?
        attributes_table_for sponsor.location do
          row :street
          row :city
          row :zip
          row :region
          row :country
        end
      end
    end

    panel "Sponsorship Details" do
      panel t(:event, scope: [:activerecord, :models], count: 3) do
        table do
          [:title, :description, "# of part.", "Type of Event", "Start Date", "Panel", "Venue"].each do |e|
            th e
          end
          sponsor.events.each do |se|
            tr do
              [se.title, se.description, se.max_number_of_participators, se.type_of_event, se.start_date, se.panel.present? ? se.panel.title : "", se.venue.present? ? se.venue.title : ""].each do |sea|
                td sea
              end
            end
          end
        end
      end

      panel "Panels" do
        table do
          ["Title", "Description", "Homepage"].each do |e|
            th e
          end
          sponsor.panels.each do |sp|
            tr do
              [sp.title, sp.description, sp.link_url].each do |spa|
                td spa
              end
            end
          end
        end
      end

    end
  end
end
