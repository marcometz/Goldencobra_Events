ActiveAdmin.register GoldencobraEvents::RegistrationUser, :as => "Applicant" do
  menu :parent => "Event-Management", :label => "Besucher"
  

  filter :firstname, :label => "Vorname"
  filter :lastname, :label => "Nachname"
  filter :email, :label => "E-Mail"

  index do
    column t(:firstname), :sortable => :firstname do |applicant|
      applicant.firstname
    end
    column t(:lastname), :sortable => :lastname do |applicant|
      applicant.lastname
    end
    column t(:email), :sortable => :email do |applicant|
      applicant.email
    end
    
    column t(:total_price) do |u|
      number_to_currency(u.total_price, :locale => :de)
    end
    default_actions
  end
  
  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs :class => "buttons inputs" do
      f.actions
    end
    
    f.inputs "Anmeldung" do
      f.input :type_of_registration, :as => :select, :collection => GoldencobraEvents::RegistrationUser::RegistrationTypes, :label => "Art der Anmeldung"
    end
    
    f.inputs "Besucher" do
      f.input :gender, :as => :select, :collection => [["Herr", true],["Frau",false]], :include_blank => false
      f.input :email     
      f.input :title     
      f.input :firstname 
      f.input :lastname  
      f.input :function  
      f.input :phone     
      f.input :agb, :label => "AGB akzeptiert"   
    end
    
    f.inputs "" do
      f.fields_for :company_attributes, f.object.company do |comp|
        comp.inputs "Firma" do
          comp.input :title
          comp.input :legal_form 
          comp.input :phone      
          comp.input :fax        
          comp.input :homepage   
          comp.input :sector  
        end 
         
        comp.inputs "" do
          comp.fields_for :location_attributes, comp.object.location do |loc|
            loc.inputs "Adresse" do
              loc.input :street, label: t('attributes.location.one.street')
              loc.input :city, label: t('attributes.location.one.city')
              loc.input :zip, label: t('attributes.location.one.zip')
              loc.input :region, label: t('attributes.location.one.region')
              loc.input :country, :as => :string, label: t('attributes.location.one.country')
              # loc.input :lat
              # loc.input :lng
            end
          end
        end
      end
    end
    
    f.inputs "" do
      f.has_many :event_registrations do |reg|
        reg.input :event_pricegroup_id, :as => :select, :collection => GoldencobraEvents::EventPricegroup.scoped.map{|a| ["#{a.event.title} (#{a.event.id}), #{a.pricegroup.title if a.pricegroup }, EUR:#{a.price}", a.id]}, :input_html => { :class => 'chzn-select', 'data-placeholder' => "Preisgruppe eines Events"} 
        reg.input :_destroy, :as => :boolean 
      end
    end
    
    
    f.inputs :class => "buttons inputs" do
      f.actions
    end
  end

  show :title => :lastname do
    panel t('active_admin.resource.applicant') do
      attributes_table_for applicant do
        row(t('attributes.user.firstname')){applicant.firstname}
        row(t('attributes.user.lastname')){applicant.lastname}
        row(t('attributes.user.title')){applicant.title}
        row(t('attributes.user.gender')){applicant.gender}
        row(t('attributes.user.function')){applicant.function}
        row(t('attributes.user.phone')){applicant.phone}
        row(t('attributes.created_at')){applicant.created_at}
        row(t('attributes.updated_at')){applicant.updated_at}
      end
    end #end panel applicant
    panel t('active_admin.resource.company') do
      if applicant.company
          attributes_table_for applicant.company do
            row(t('attributes.company.title')){applicant.company.title}
            row(t('attributes.company.legal_form')){applicant.company.legal_form}
            row(t('attributes.company.phone')){applicant.company.phone}
            row(t('attributes.company.fax')){applicant.company.fax}
            row(t('attributes.company.homepage')){applicant.company.homepage}
            row(t('attributes.company.sector')){applicant.company.sector}
          end
        if applicant.company.location 
          attributes_table_for applicant.company.location do
            row(t('attributes.location.street.one')){applicant.company.location.street}
            row(t('attributes.location.zip.one')){applicant.company.location.zip}
            row(t('attributes.location.city.one')){applicant.company.location.city}
            row(t('attributes.location.region.one')){applicant.company.location.region}
            row(t('attributes.location.country.one')){applicant.company.location.country}
          end
        end
      end   
    end
    panel t('active_admin.resource.event_registration') do
      table do
        tr do
          th t('attributes.event.title')
          th t('attributes.event_pricegroup.title.')
          th t('attributes.event_pricegroup.price')
          th t('attributes.created_at')
        end
        applicant.event_registrations.each do |ereg|
          tr do
            [ereg.event_pricegroup.event.title, ereg.event_pricegroup.title, number_to_currency(ereg.event_pricegroup.price, :locale => :de), l(ereg.created_at, format: :short)].each do |esa|
              td esa
            end
          end
        end
        tr :class => "total" do
          td ""
          td ""
          td number_to_currency(applicant.total_price, :locale => :de)
          td ""
        end
      end
    end #end panel sponsors
  end
  
  controller do     
    def new       
      @applicant = GoldencobraEvents::RegistrationUser.new
      @applicant.company = GoldencobraEvents::Company.new
      @applicant.company.location = Goldencobra::Location.new
    end 
  end
  
end
