ActiveAdmin.register GoldencobraEvents::Pricegroup, :as => "Pricegroup" do
    
    menu :parent => "Event-Management", :label => "Preisgruppen"

  action_item :only => :show do
    link_to('New Pricegroup', new_admin_pricegroup_path)
  end

end
