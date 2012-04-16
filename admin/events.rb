ActiveAdmin.register GoldencobraEvents::Event, :as => "Event" do
  
  menu :parent => "Event-Management", :label => "Veranstaltungen", :if => proc{can?(:read, GoldencobraEvents::Event)}
  controller.authorize_resource :class => GoldencobraEvents::Event
  
  filter :title, :label => "Veranstaltungsname"
  filter :start_date, :label => "Beginn"
  filter :end_date, :label => "Ende"
  filter :venue, :label => "Veranstaltungsort"
  filter :type_of_event, :label => "Art der Anmeldung"
  
  
  form :html => { :enctype => "multipart/form-data" }  do |f|
    f.inputs "" do 
      f.actions
    end
    f.inputs "Allgemein" do
      f.input :title, :hint => "Der Titel der Seite, kann Leerzeichen und Sonderzeichen enthalten", label: t('activerecord.attributes.event.title')
      f.input :start_date, :start_year => Date.today.year, :include_blank => false, :order => [:day, :month, :year], :include_blank => true, label: t('activerecord.attributes.event.start_date')
      f.input :end_date, :start_year => Date.today.year, :include_blank => false, :order => [:day, :month, :year], :include_blank => true, label: t('activerecord.attributes.event.end_date')
      f.input :parent_id, :as => :select, :collection => GoldencobraEvents::Event.all.map{|c| [c.title, c.id]}, :include_blank => true, label: t('activerecord.attributes.event.parent_id')
      f.input :type_of_event, :as => :select, :collection => GoldencobraEvents::Event::EventType.map{|c| c}, :include_blank => false, label: t('activerecord.attributes.event.type_of_event')
      f.input :type_of_registration, :as => :select, :collection => GoldencobraEvents::Event::RegistrationType.map{|c| c}, :include_blank => false, label: t('activerecord.attributes.event.type_of_registration')
      f.input :active, :hint => "Ist dieser Event online zu sehen?", label: t('activerecord.attributes.event.active')
      f.input :exclusive, :hint => "Kinder dieser Veranstaltung sind Exclusiv, f&uuml;r eines der Kinder muss sich dann entscheiden werden!", label: t('activerecord.attributes.event.exclusive')
    end
    
    f.inputs "Preisgruppen" do
      f.has_many :event_pricegroups do |m|
        m.input :pricegroup, :include_blank => "default", :input_html => { :class => 'pricegroup_pricegroup'}, label: t('active_admin.resource.pricegroup')
        m.input :price_raw, label: t('activerecord.attributes.event_pricegroup.price'), :input_html => { :class => 'pricegroup_price', :maxlength => 10, :value => "#{m.object.price}" }
        m.input :max_number_of_participators, :input_html => { :class => 'pricegroup_numbers'}, label: t('activerecord.attributes.event_pricegroup.max_number_of_participators')
        m.input :start_reservation, :start_year => Date.today.year, :include_blank => false, :order => [:day, :month, :year], label: t('activerecord.attributes.event_pricegroup.start_reservation')
        m.input :end_reservation, :start_year => Date.today.year, :include_blank => false, :order => [:day, :month, :year], label: t('activerecord.attributes.event_pricegroup.end_reservation')
        m.input :cancelation_until, :start_year => Date.today.year, :include_blank => false, :order => [:day, :month, :year], label: t('activerecord.attributes.event_pricegroup.cancelation_until')
        m.input :webcode, :hint => "Wenn hier ein Code angegeben ist, ist diese Preisgruppe nicht mehr &ouml;ffentlich sichtbar, sondern nur noch mit oben genanntem Webcode.", label: t('activerecord.attributes.event_pricegroup.webcode')
        m.input :available, :as => :boolean, label: t('activerecord.attributes.event_pricegroup.available')
      end
    end    

    f.inputs "Information" do
      f.input :panel, :as => :select, :collection => GoldencobraEvents::Panel.all.map{|c| [c.title, c.id]}, :include_blank => true, :input_html => { :class => 'chzn-select', :style => 'width: 70%;', 'data-placeholder' => t('active_admin.events.chose_panel')}, label: t('active_admin.resource.panel')
      f.input :venue, :as => :select, :collection => GoldencobraEvents::Venue.all.map{|c| [c.title, c.id]}, :include_blank => true, :input_html => { :class => 'chzn-select', :style => 'width: 70%;', 'data-placeholder' => t('active_admin.events.chose_venue')}, label: t('active_admin.resource.venue')
      f.input :sponsors, as: :check_boxes, :collection => GoldencobraEvents::Sponsor.find(:all, :order => "title ASC"), :input_html => { }, label: t('active_admin.resource.sponsor')
      f.input :artists, as: :check_boxes, :collection => GoldencobraEvents::Artist.find(:all, :order => "title ASC"), :input_html => { }, label: t('active_admin.resource.artist')
      f.input :max_number_of_participators, label: t('activerecord.attributes.event.max_number_of_participators'), hint: t('active_admin.not_needed')
    end
    
    f.inputs "Inhalt" do
      f.input :teaser_image, :as => :select, :collection => Goldencobra::Upload.all.map{|c| [c.complete_list_name, c.id]}, :input_html => { :class => 'teaser_image'}, label: t('activerecord.attributes.event.teaser_image'), hint: t('active_admin.not_needed')
      f.input :description, :hint => "Beschreibung des Events", :input_html => { :class =>"tinymce"}, label: t('activerecord.attributes.event.description'), hint: t('active_admin.not_needed')
      f.input :external_link, label: t('activerecord.attributes.event.external_link'), hint: t('active_admin.not_needed')
    end
  end
    
  
  index do 
    column t('activerecord.attributes.event.title'), :sortable => :title do |event|
      event.title
    end
    column t('activerecord.attributes.event.active'), :sortable => :active do |event|
      event.active
    end
    column t('activerecord.attributes.event.exclusive'), :sortable => :exclusive do |event|
      event.exclusive
    end
    column t('activerecord.attributes.event.type_of_event'), :sortable => :type_of_event do |event|
      event.type_of_event
    end
    column t(:updated_at) do |event|
      l(event.updated_at, format: :short)
    end
    column "" do |event|
      result = ""
      result += link_to(t('active_admin.edit'), edit_admin_event_path(event), :class => "member_link edit_link")
      result += link_to(t('active_admin.events.new_subevent'), new_admin_event_path(:parent => event), :class => "member_link edit_link")
      result += link_to(t('active_admin.delete'), admin_event_path(event), :method => :DELETE, :confirm => "Realy want to delete this Event?", :class => "member_link delete_link")
      raw(result)
    end
  end
  
  # action_item do
  #   link_to('New Event', new_admin_event_path)
  # end
  
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
            td number_to_currency(epg.price, :locale => :de)
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
  
  sidebar "Ueberblick", only: [:index]  do
    render :partial => "/goldencobra/admin/shared/overview", :object => GoldencobraEvents::Event.roots, :locals => {:link_name => "title", :url_path => "event" }
  end

  sidebar "Zeitlinie", only: [:index]  do
    render :partial => "/goldencobra_events/admin/events/timeline", :object => GoldencobraEvents::Event.active, :locals => {:link_name => "title", :url_path => "event" }
  end
  
  
  controller do 
    
    def show
      show! do |format|
         format.html { redirect_to edit_admin_event_path(@event), :flash => flash }
      end
    end
            
    def new 
      @event = GoldencobraEvents::Event.new
      @event.event_pricegroups << GoldencobraEvents::EventPricegroup.new(:price => 0, :max_number_of_participators => 0)
      if params[:parent] && params[:parent].present? 
        @parent = GoldencobraEvents::Event.find(params[:parent])
        @event.parent_id = @parent.id
      end
      @event.set_start_end_dates if @event.parent
    end 
  end
  
  
end
