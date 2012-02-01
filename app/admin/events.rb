ActiveAdmin.register GoldencobraEvents::Event, :as => "Event" do
  
  form :html => { :enctype => "multipart/form-data" }  do |f|
    f.inputs "Allgemein" do
      f.input :title, :hint => "Der Titel der Seite, kann Leerzeichen und Sonderzeichen enthalten"
      f.input :parent_id, :as => :select, :collection => GoldencobraEvents::Event.all.map{|c| [c.title, c.id]}, :include_blank => true
      f.input :active, :hint => "Ist dieser Event online zu sehen?"
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