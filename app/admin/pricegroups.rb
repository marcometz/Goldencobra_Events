ActiveAdmin.register GoldencobraEvents::Pricegroup, :as => "Pricegroup" do
    
  menu :parent => "Event-Management", :label => "Preisgruppen"
  
  filter :title

  action_item :only => :show do
    link_to(t('active_admin.pricegroups.new_pricegroup'), new_admin_pricegroup_path)
  end

end
