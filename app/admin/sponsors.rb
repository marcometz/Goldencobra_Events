ActiveAdmin.register GoldencobraEvents::Sponsor, :as => "Sponsor" do
  
  menu :parent => "Event-Management"
  
  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs "Allgemein" do
      f.input :title
      f.input :description
      f.input :link_url, :label => "Homepage Link"
      f.input :size_of_sponsorship, :as => :select, :collection => GoldencobraEvents::Sponsor::SponsorshipSize.map {|c| c}, :include_blank => false
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
