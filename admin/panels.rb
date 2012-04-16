ActiveAdmin.register GoldencobraEvents::Panel, :as => "Event Panel" do
  menu :parent => "Event-Management", :label => "Panels", :if => proc{can?(:read, GoldencobraEvents::Panel)}
  controller.authorize_resource :class => GoldencobraEvents::Panel

  filter :title

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs :class => "buttons inputs" do
      f.actions
    end
    f.inputs "Allgemein" do
      f.input :title, :hint => "Der Titel des Panels, kann Leerzeichen und Sonderzeichen enthalten", label: t('activerecord.attributes.panel.title')
      f.input :description, :hint => "Die Beschreibung des Panels", label: t('activerecord.attributes.panel.description')
      f.input :link_url, :hint => "Link zur Panel-Seite", label: t('activerecord.attributes.panel.link_url')
    end

    f.inputs "Informationen" do
      f.input :sponsors, as: :check_boxes, :collection => GoldencobraEvents::Sponsor.find(:all, :order => "title ASC"), label: t('activerecord.attributes.panel.sponsors')#, input_html: { class: 'chzn-select', 'data-placeholder' => t(:select_sponsor), style: "width: 50%;" }
    end
    f.inputs :class => "buttons inputs" do
      f.actions
    end
  end

  index do
    column t('activerecord.attributes.panel.title'), :sortable => :title do |event_panel|
      event_panel.title
    end
    column t('activerecord.attributes.panel.description'), :sortable => :description do |event_panel|
      event_panel.description
    end
    column t('activerecord.attributes.panel.link_url'), :sortable => :link_url do |event_panel|
      event_panel.link_url
    end
    column t('activerecord.attributes.updated_at'), :sortable => :updated_at do |event_panel|
      event_panel.updated_at
    end
    column "" do |event_panel|
      result = ""
      result += link_to(t('active_admin.view'), admin_event_panel_path(event_panel), :class => "member_link view_link")
      result += link_to(t('active_admin.edit'), edit_admin_event_panel_path(event_panel), :class => "member_link edit_link")
      result += link_to(t('active_admin.delete'), admin_event_panel_path(event_panel), :method => :DELETE, :confirm => "Really want to delete this Panel?", :class => "member_link delete_link")
      raw(result)
    end
  end

  action_item :only => :show do
    link_to('New Panel', new_admin_event_panel_path)
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
       [:title, :description, "Size of sponsorship", "Type of sponsorship"].each do |c|
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
