ActiveAdmin.register Goldencobra::Article, :as => "Article" do

  menu :parent => "Content-Management", :label => "Artikel"
  
  sidebar :event_module, :only => [:edit] do      
    render "/goldencobra_events/admin/events/event_module_sidebar"
  end

  sidebar :artist_list_module, only: [:edit] do
    render "/goldencobra_events/admin/events/artist_list_module_sidebar"
  end

  sidebar :sponsor_list_module, only: [:edit] do
    render "/goldencobra_events/admin/events/sponsor_module_sidebar"
  end

  
end
