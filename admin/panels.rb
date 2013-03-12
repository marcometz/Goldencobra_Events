ActiveAdmin.register GoldencobraEvents::Panel, :as => "Event_Panel" do

  menu :parent => "Event-Management", :if => proc{can?(:read, GoldencobraEvents::Panel) && (Goldencobra::Setting.for_key('goldencobra_events.active_admin.menue.panels.display') != "false")}
  controller.authorize_resource :class => GoldencobraEvents::Panel

  filter :title

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs :class => "buttons inputs" do
      f.actions
    end
    f.inputs "Allgemein" do
      f.input :title, :hint => "Der Titel des Panels, kann Leerzeichen und Sonderzeichen enthalten"
      f.input :description, :hint => "Die Beschreibung des Panels"
      f.input :link_url, :hint => "Link zur Panel-Seite"
    end

    f.inputs "Informationen" do
      f.input :sponsors, as: :check_boxes, :collection => GoldencobraEvents::Sponsor.find(:all, :order => "title ASC")
    end
    f.inputs :class => "buttons inputs" do
      f.actions
    end
  end

  index do
    column :title, :sortable => :title do |event_panel|
      event_panel.title
    end
    column :description, :sortable => :description do |event_panel|
      event_panel.description
    end
    column :link_url, :sortable => :link_url do |event_panel|
      event_panel.link_url
    end
    column :updated_at, :sortable => :updated_at do |event_panel|
      event_panel.updated_at
    end
    default_actions
  end

  action_item :only => :show do
    link_to('New Panel', new_admin_event_panel_path)
  end

  action_item only: [:edit, :show] do
    render partial: '/goldencobra/admin/shared/prev_item'
  end

  action_item only: [:edit, :show] do
    render partial: '/goldencobra/admin/shared/next_item'
  end

  show :title => :title do
    panel "Panel Details" do
      attributes_table_for event_panel do
        row :title
        row :description
        row :created_at
        row :updated_at
      end
    end
    panel "Sponsors" do
     table do
       [:title, :description, :size_of_sponsorship, :type_of_sponsorship].each do |c|
         th c
       end
       event_panel.sponsors.each do |es|
         tr do
           [es.title, es.description, es.size_of_sponsorship, es.type_of_sponsorship].each do |esa|
             td esa
           end
         end
       end
     end
   end
   active_admin_comments
  end

end
