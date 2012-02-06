ActiveAdmin.register GoldencobraEvents::Event, :as => "Event" do
  
  menu :parent => "Event-Management"
  
  form :html => { :enctype => "multipart/form-data" }  do |f|
    f.inputs "Allgemein" do
      f.input :title, :hint => "Der Titel der Seite, kann Leerzeichen und Sonderzeichen enthalten"
      f.input :start_date, :start_year => Date.today.year, :include_blank => false, :order => [:day, :month, :year]
      f.input :end_date, :start_year => Date.today.year, :include_blank => false, :order => [:day, :month, :year]
      f.input :parent_id, :as => :select, :collection => GoldencobraEvents::Event.all.map{|c| [c.title, c.id]}, :include_blank => true
      f.input :active, :hint => "Ist dieser Event online zu sehen?"
    end
    
    f.inputs "Preisgruppen" do
      f.has_many :event_pricegroups do |m|
        m.input :pricegroup, :include_blank => false
        m.input :price, :input_html => { :class => 'pricegroup_price'} 
        m.input :max_number_of_participators, :input_html => { :class => 'pricegroup_numbers'} 
        m.input :start_reservation, :start_year => Date.today.year, :include_blank => false, :order => [:day, :month, :year]
        m.input :end_reservation, :start_year => Date.today.year, :include_blank => false, :order => [:day, :month, :year]
        m.input :cancelation_until, :start_year => Date.today.year, :include_blank => false, :order => [:day, :month, :year]
        m.input :webcode, :hint => "Wenn hier ein Code angegeben ist, ist diese Preisgruppe nicht mehr &ouml;ffentlich sichtbar, sondern nur noch mit oben genanntem Webcode."
        m.input :available, :as => :boolean 
      end
    end    

    f.inputs "Panel" do
      f.input :panel, :as => :select, :collection => GoldencobraEvents::Panel.all.map{|c| [c.title, c.id]}, :include_blank => true
    end
    
    f.inputs "Inhalt" do
      f.input :description, :hint => "Beschreibung des Events", :input_html => { :class =>"tinymce"}
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
  
  
  show :title => :title do
    panel "Venue Details" do
      attributes_table_for event do
        row :title
        row :description
        row :start_date
        row :end_date
        row :active
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
      	    td epg.pricegroup.title
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
    active_admin_comments
  end
  
  controller do 
    def new 
      @event = GoldencobraEvents::Event.new
      if params[:parent] && params[:parent].present? 
        @parent = GoldencobraEvents::Event.find(params[:parent])
        @event.parent_id = @parent.id
      end
    end 
  end
  
  
end
