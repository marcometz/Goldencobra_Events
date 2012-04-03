ActiveAdmin.register Goldencobra::Article, :as => "Article" do

  menu :parent => "Content-Management", :label => "Artikel"
  
  sidebar "Veranstaltungs Modul", :only => [:edit] do      #:event_module
    render "/goldencobra_events/admin/events/event_module_sidebar"
  end

  sidebar "Rednerlisten Modul", only: [:edit] do
    render "/goldencobra_events/admin/events/artist_list_module_sidebar"
  end

  sidebar "Sponsoren Modul", only: [:edit] do
    render "/goldencobra_events/admin/events/sponsor_module_sidebar"
  end

  
end
