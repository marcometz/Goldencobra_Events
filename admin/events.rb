ActiveAdmin.register GoldencobraEvents::Event, :as => "Event" do
  
  menu :parent => "Event-Management", :label => "Veranstaltungen", :if => proc{can?(:read, GoldencobraEvents::Event)}
  controller.authorize_resource :class => GoldencobraEvents::Event
  
  scope "Alle", :scoped, :default => true
  scope :active
  scope :inactive
  
  filter :title
  filter :start_date
  filter :end_date
  filter :venue
  filter :type_of_event
  
  
  form :html => { :enctype => "multipart/form-data" }  do |f|
    f.inputs :class => "buttons inputs" do
      f.actions
    end
    f.inputs "Allgemein" do
      f.input :title, :hint => "Der Titel der Seite, kann Leerzeichen und Sonderzeichen enthalten"
      f.input :start_date, as: :string, :input_html => { class: "datepicker", :size => "20", value: "#{f.object.start_date.strftime('%A, %d.%m.%Y') if f.object.start_date}" }
      f.input :end_date, as: :string, :input_html => { class: "datepicker", :size => "20", value: "#{f.object.end_date.strftime('%A, %d.%m.%Y') if f.object.end_date}" }
      f.input :parent_id, :as => :select, :collection => GoldencobraEvents::Event.all.map{|c| [c.title, c.id]}, :include_blank => true
      f.input :type_of_event, :as => :select, :collection => GoldencobraEvents::Event::EventType.map{|c| c}, :include_blank => false
      f.input :type_of_registration, :as => :select, :collection => GoldencobraEvents::Event::RegistrationType.map{|c| c}, :include_blank => false
      f.input :active, :hint => "Ist dieser Event online zu sehen?"
      f.input :exclusive, :hint => "Kinder dieser Veranstaltung sind Exclusiv, f&uuml;r eines der Kinder muss sich dann entscheiden werden!"
    end
    
    f.inputs "Preisgruppen" do
      f.has_many :event_pricegroups do |m|
        m.input :pricegroup, :include_blank => "default", :input_html => { :class => 'pricegroup_pricegroup'}
        m.input :price_raw, :input_html => { :class => 'pricegroup_price', :maxlength => 10, :value => "#{m.object.price}" }
        m.input :max_number_of_participators, :input_html => { :class => 'pricegroup_numbers'}
        m.input :start_reservation, as: :string, :input_html => { class: "datepicker", :size => "20", value: "#{m.object.start_reservation.strftime('%A, %d.%m.%Y') if m.object.start_reservation}" }
        m.input :end_reservation, as: :string, :input_html => { class: "datepicker", :size => "20", value: "#{m.object.end_reservation.strftime('%A, %d.%m.%Y') if m.object.end_reservation}" }
        m.input :cancelation_until, as: :string, :input_html => { class: "datepicker", :size => "20", value: "#{m.object.cancelation_until.strftime('%A, %d.%m.%Y') if m.object.cancelation_until}" }
        m.input :webcode, :hint => "Wenn hier ein Code angegeben ist, ist diese Preisgruppe nicht mehr &ouml;ffentlich sichtbar, sondern nur noch mit oben genanntem Webcode."
        m.input :available, :as => :boolean
      end
    end    

    f.inputs "Information" do
      f.input :panel, :as => :select, :collection => GoldencobraEvents::Panel.all.map{|c| [c.title, c.id]}, :include_blank => true, :input_html => { :class => 'chzn-select', :style => 'width: 70%;', 'data-placeholder' => t('active_admin.events.chose_panel')} if GoldencobraEvents::Panel.all.count > 0
      f.input :venue, :as => :select, :collection => GoldencobraEvents::Venue.all.map{|c| [c.title, c.id]}, :include_blank => true, :input_html => { :class => 'chzn-select', :style => 'width: 70%;', 'data-placeholder' => t('active_admin.events.chose_venue')}
      f.input :sponsors, as: :check_boxes, :collection => GoldencobraEvents::Sponsor.find(:all, :order => "title ASC"), :input_html => { }
      f.input :artists, as: :check_boxes, :collection => GoldencobraEvents::Artist.find(:all, :order => "title ASC"), :input_html => { }
      f.input :max_number_of_participators, hint: t('active_admin.not_needed')
    end
    
    f.inputs "Inhalt" do
      f.input :teaser_image, :as => :select, :collection => Goldencobra::Upload.all.map{|c| [c.complete_list_name, c.id]}, :input_html => { :class => 'teaser_image'}, hint: t('active_admin.not_needed')
      f.input :description, :hint => "Beschreibung des Events", :input_html => { :class =>"tinymce"}, hint: t('active_admin.not_needed')
      f.input :external_link, hint: t('active_admin.not_needed')
    end
    f.inputs :class => "buttons inputs" do
      f.actions
    end
  end
    
  
  index do 
    column :title, :sortable => :title do |event|
      event.title
    end
    column :active, :sortable => :active do |event|
      event.active
    end
    column :type_of_event, :sortable => :type_of_event do |event|
      event.type_of_event
    end
    column :updated_at do |event|
      l(event.updated_at, format: :short)
    end
    column "Regs" do |event|
      event.event_pricegroups.joins(:event_registrations => :user).where("goldencobra_events_registration_users.active = true").collect(&:event_registrations).count
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
  
  batch_action :destroy, false
  
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
  
  
  csv do
    column :id
    column :title
    column :description
    column :created_at
    column :updated_at
    column :active
    column :exclusive
    column :external_link
    column :max_number_of_participators
    column :type_of_event
    column :type_of_registration
    column :start_date
    column :end_date
    column :venue_id
    column("Registrations") {|event| event.event_pricegroups.joins(:event_registrations => :user).where("goldencobra_events_registration_users.active = true").collect(&:event_registrations).count }
  end
  
  
end
