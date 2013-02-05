ActiveAdmin.register GoldencobraEvents::Pricegroup, :as => "Pricegroup" do

  menu :parent => "Event-Management", :label => "Preisgruppen", :if => proc{can?(:read, GoldencobraEvents::Pricegroup)}
  controller.authorize_resource :class => GoldencobraEvents::Pricegroup

  filter :title

  form :html => { :enctype => "multipart/form-data" }  do |f|
    f.actions
    f.inputs 'Allgemein' do
      f.input :title
      f.input :email_text, input_html: { class: "tinymce" }
      f.input :show_details_in_email, hint: 'Sollen Adresse, Rechnungsadresse und weitere Details zu dieser Preisgruppe erscheinen?'
    end
    f.actions
  end

  action_item :only => :show do
    link_to(t('active_admin.pricegroups.new_pricegroup'), new_admin_pricegroup_path)
  end

  batch_action :destroy, false

end
