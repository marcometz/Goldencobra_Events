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
            row(t('attributes.location.street')){applicant.company.location.street}
            row(t('attributes.location.zip')){applicant.company.location.zip}
            row(t('attributes.location.city')){applicant.company.location.city}
            row(t('attributes.location.region')){applicant.company.location.region}
            row(t('attributes.location.country')){applicant.company.location.country}
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
        end
        applicant.event_registrations.each do |ereg|
          tr do
            [ereg.event_pricegroup.event.title, ereg.event_pricegroup.title, number_to_currency(ereg.event_pricegroup.price, :locale => :de)].each do |esa|
              td esa
            end
          end
        end
        tr :class => "total" do
          td ""
          td "Summe:"
          td number_to_currency(applicant.total_price, :locale => :de)
        end
      end
    end #end panel sponsors
  end
end
