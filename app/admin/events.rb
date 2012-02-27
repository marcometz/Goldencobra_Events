ActiveAdmin.register GoldencobraEvents::Event, :as => "Event" do
  
  menu :parent => "Event-Management"
  
  form :html => { :enctype => "multipart/form-data" }  do |f|
    f.inputs "Allgemein" do
      f.input :title, :hint => "Der Titel der Seite, kann Leerzeichen und Sonderzeichen enthalten"
      f.input :start_date, :start_year => Date.today.year, :include_blank => false, :order => [:day, :month, :year], :include_blank => true
      f.input :end_date, :start_year => Date.today.year, :include_blank => false, :order => [:day, :month, :year], :include_blank => true
      f.input :parent_id, :as => :select, :collection => GoldencobraEvents::Event.all.map{|c| [c.title, c.id]}, :include_blank => true
      f.input :type_of_event, :as => :select, :collection => GoldencobraEvents::Event::EventType.map{|c| c}, :include_blank => false
      f.input :type_of_registration, :as => :select, :collection => GoldencobraEvents::Event::RegistrationType.map{|c| c}, :include_blank => false
      f.input :active, :hint => "Ist dieser Event online zu sehen?"
      f.input :exclusive, :hint => "Kinder dieser Veranstaltung sind Exclusiv, f&uuml;r eines der Kinder muss sich dann entscheiden werden!"
    end
    
    f.inputs "Preisgruppen" do
      f.has_many :event_pricegroups do |m|
        m.input :pricegroup, :include_blank => "default"
        m.input :price_raw, :label => "Price", :input_html => { :class => 'pricegroup_price', :maxlength => 10, :value => "#{m.object.price}" }
        m.input :max_number_of_participators, :input_html => { :class => 'pricegroup_numbers'} 
        m.input :start_reservation, :start_year => Date.today.year, :include_blank => false, :order => [:day, :month, :year]
        m.input :end_reservation, :start_year => Date.today.year, :include_blank => false, :order => [:day, :month, :year]
        m.input :cancelation_until, :start_year => Date.today.year, :include_blank => false, :order => [:day, :month, :year]
        m.input :webcode, :hint => "Wenn hier ein Code angegeben ist, ist diese Preisgruppe nicht mehr &ouml;ffentlich sichtbar, sondern nur noch mit oben genanntem Webcode."
        m.input :available, :as => :boolean 
      end
    end    

    f.inputs "Information" do
      f.input :panel, :as => :select, :collection => GoldencobraEvents::Panel.all.map{|c| [c.title, c.id]}, :include_blank => true
      f.input :venue, :as => :select, :collection => GoldencobraEvents::Venue.all.map{|c| [c.title, c.id]}, :include_blank => true
      f.input :sponsors, :as => :check_boxes, :collection => GoldencobraEvents::Sponsor.find(:all, :order => "title ASC")
      f.input :artists, :as => :check_boxes, :collection => GoldencobraEvents::Artist.find(:all, :order => "title ASC")
      f.input :max_number_of_participators
    end
    
    f.inputs "Inhalt" do
      f.input :teaser_image, :as => :select, :collection => Goldencobra::Upload.all.map{|c| [c.complete_list_name, c.id]}, :input_html => { :class => 'teaser_image'} 
      f.input :description, :hint => "Beschreibung des Events", :input_html => { :class =>"tinymce"}
      f.input :external_link
    end
    f.buttons
  end
  
  index do 
    column :title
    column :active
    column :exclusive
    column :updated_at
    column "" do |event|
      result = ""
      result += link_to("New Subevent", new_admin_event_path(:parent => event), :class => "member_link edit_link")
      result += link_to("View", admin_event_path(event), :class => "member_link view_link")
      result += link_to("Edit", edit_admin_event_path(event), :class => "member_link edit_link")
      result += link_to("Delete", admin_event_path(event), :method => :DELETE, :confirm => "Realy want to delete this Event?", :class => "member_link delete_link")
      raw(result)
    end
  end
  
  action_item :only => :show do
    link_to('New Event', new_admin_event_path)
  end
  
  show :title => :title do
    panel "Event Details" do
      attributes_table_for event do
        row :title
        row :description
        row :start_date
        row :end_date
        row :active
        row :type_of_event
        row :type_of_registration
        row :created_at
        row :updated_at
      end
    end
    panel "Pricegroups" do
      table do
        tr do
          th "Title"
          th "Price"
          th "Max Count"
          th "Start"
          th "End"
          th "Cancel"
          th "Available"
          th "Webcode"
        end
        event.event_pricegroups.each do |epg|
      	  tr do
      	    td epg.title
            td number_to_currency(epg.price)
      	    td epg.max_number_of_participators
      	    td epg.start_reservation
      	    td epg.end_reservation
      	    td epg.cancelation_until
      	    td epg.available
      	    td epg.webcode
      	  end
        end
      end      
    end
    if event.panel.present?
      panel "Panel" do
        attributes_table_for event.panel do
          row :title
          row :description
        end
      end
    end
    panel "Sponsors" do
      table do
        [:title, :description, "Size of sponsorship", "Type of sponsorship"].each do |c|
          th c
        end
        event.sponsors.each do |es|
          tr do
            [es.title, es.description, es.size_of_sponsorship, es.type_of_sponsorship].each do |esa|
              td esa
            end
          end
        end
      end
    end #end panel sponsors
    panel "Artists" do
      table do
        tr do
          [:title, :description, :url_link, :telephone, :email, :updated_at].each do |aa|
            th aa
          end
        end
        event.artists.each do |ea|
          tr do
            [ea.title, ea.description, ea.url_link, ea.telephone, ea.email, ea.updated_at].each do |eaa|
              td eaa
            end
          end
        end
      end
    end
    active_admin_comments
  end
  
  controller do 
    def new 
      @event = GoldencobraEvents::Event.new
      @event.event_pricegroups << GoldencobraEvents::EventPricegroup.new(:price => 0, :max_number_of_participators => 0)
      if params[:parent] && params[:parent].present? 
        @parent = GoldencobraEvents::Event.find(params[:parent])
        @event.parent_id = @parent.id
      end
    end 
  end
  
  
end
