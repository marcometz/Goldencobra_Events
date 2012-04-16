ActiveAdmin.register GoldencobraEvents::Sponsor, :as => "Sponsor" do
  
  menu :parent => "Event-Management", :label => "Sponsoren", :if => proc{can?(:read, GoldencobraEvents::Sponsor)}
  controller.authorize_resource :class => GoldencobraEvents::Sponsor
  
  filter :title, label: "Name"
  filter :email, label: "E-Mail"
  filter :link_url, label: "Homepage"
  
  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs :class => "buttons inputs" do
      f.actions
    end
    f.inputs "Allgemein" do
      f.input :title
      f.input :description, :input_html => { :class =>"tinymce"}
      f.input :link_url, :label => "Homepage"
      f.input :size_of_sponsorship, :as => :select, :collection => GoldencobraEvents::Sponsor::SponsorshipSize.map {|c| c}, :include_blank => false, label: t('activerecord.attributes.sponsor.size_of_sponsorship'), :input_html => { :class => 'chzn-select'}
      f.input :email, label: t('activerecord.attributes.sponsor.email')
      f.input :telephone, label: t('activerecord.attributes.sponsor.telephone')
    end
    f.inputs "Adresse" do
      f.fields_for :location_attributes, f.object.location do |loc|
        loc.inputs "" do
          loc.input :street, label: t('activerecord.attributes.location.street.one')
          loc.input :city, label: t('activerecord.attributes.location.city.one')
          loc.input :zip, label: t('activerecord.attributes.location.zip.one')
          loc.input :region, label: t('activerecord.attributes.location.region.one')
          loc.input :country, :as => :string, label: t('activerecord.attributes.location.country.one')
        end
      end
    end
    f.inputs "Bilder" do
      f.input :logo, :as => :select, :collection => Goldencobra::Upload.all.map{|c| [c.complete_list_name, c.id]}, :input_html => { :class => 'sponsor_logo_image_file chzn-select'} 
      f.has_many :sponsor_images do |si|
        si.input :image, :as => :select, :collection => Goldencobra::Upload.all.map{|c| [c.complete_list_name, c.id]}, :input_html => { :class => 'sponsor_image_file chzn-select'}
      end
    end
    f.inputs :class => "buttons inputs" do
      f.actions
    end
  end

  index do
    column t('activerecord.attributes.sponsor.title'), :sortable => :title do |sponsor|
      sponsor.title
    end
    column t('activerecord.attributes.sponsor.description') do |sponsor|
      sponsor.description
    end
    column t('activerecord.attributes.sponsor.email') do |sponsor|
      sponsor.email
    end
    column t('activerecord.attributes.sponsor.link_url'), :sortable => :link_url do |sponsor|
      sponsor.link_url
    end
    column t('activerecord.attributes.sponsor.telephone') do |sponsor|
      sponsor.telephone
    end
    default_actions
  end

  action_item :only => :show do
    link_to('New Sponsor', new_admin_sponsor_path)
  end

  show :title => :title do
    panel "Sponsor Details" do
      attributes_table_for sponsor do
        [:title, :description, :link_url, :email, :telephone, :size_of_sponsorship, :type_of_sponsorship, :created_at, :updated_at].each do |s|
          row s
        end
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
      panel "Events" do
        table do
          ["Title", "Description", "# of part.", "Type of Event", "Start Date", "Panel", "Venue"].each do |e|
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
