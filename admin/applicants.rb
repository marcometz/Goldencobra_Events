ActiveAdmin.register GoldencobraEvents::RegistrationUser, :as => "Applicant" do
  menu :parent => "Event-Management", :label => "Besucher", :if => proc{can?(:read, GoldencobraEvents::RegistrationUser)}
  controller.authorize_resource :class => GoldencobraEvents::RegistrationUser

  filter :firstname, :label => "Vorname"
  filter :lastname, :label => "Nachname"
  filter :email, :label => "E-Mail"
  filter :type_of_registration, :label => "Art der Registrierung", :as => :select, :collection => GoldencobraEvents::RegistrationUser::RegistrationTypes

  index do
    selectable_column
    column t(:firstname), :sortable => :firstname do |applicant|
      applicant.firstname
    end
    column t(:lastname), :sortable => :lastname do |applicant|
      applicant.lastname
    end
    column t(:email), :sortable => :email do |applicant|
      applicant.email
    end
    column "Art", :type_of_registration
    column t(:total_price) do |u|
      number_to_currency(u.total_price, :locale => :de)
    end
    column "E-Mail" do |user|
      link_to("senden", send_conf_mail_admin_applicant_path(user)) 
    end
    default_actions
  end
  
  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs :class => "buttons inputs" do
      f.actions
    end
    f.inputs "Anmeldung" do
      f.input :type_of_registration, :as => :select, :collection => GoldencobraEvents::RegistrationUser::RegistrationTypes, :label => "Art der Anmeldung"
      f.input :comment, :label => "Kommentar", :input_html => {:rows => 3}
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
        reg.input :event_pricegroup_id, :as => :select, :collection => GoldencobraEvents::EventPricegroup.scoped.map{|a| ["#{a.event.title if a.event} (#{a.event.id if a.event}), #{a.pricegroup.title if a.pricegroup }, EUR:#{a.price}", a.id]}, :input_html => { :class => 'chzn-select', 'data-placeholder' => "Preisgruppe eines Events"} 
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
        row(t('activerecord.attributes.user.firstname')){applicant.firstname}
        row(t('activerecord.attributes.user.lastname')){applicant.lastname}
        row(t('activerecord.attributes.user.title')){applicant.title}
        row(t('activerecord.attributes.user.gender')){applicant.gender}
        row(t('activerecord.attributes.user.function')){applicant.function}
        row(t('activerecord.attributes.user.phone')){applicant.phone}
        row(t('activerecord.attributes.created_at')){applicant.created_at}
        row(t('activerecord.attributes.updated_at')){applicant.updated_at}
      end
    end #end panel applicant
    panel t('active_admin.resource.company') do
      if applicant.company
          attributes_table_for applicant.company do
            row(t('activerecord.attributes.company.title')){applicant.company.title}
            row(t('activerecord.attributes.company.legal_form')){applicant.company.legal_form}
            row(t('activerecord.attributes.company.phone')){applicant.company.phone}
            row(t('activerecord.attributes.company.fax')){applicant.company.fax}
            row(t('activerecord.attributes.company.homepage')){applicant.company.homepage}
            row(t('activerecord.attributes.company.sector')){applicant.company.sector}
          end
        if applicant.company.location 
          attributes_table_for applicant.company.location do
            row(t('activerecord.attributes.location.street.one')){applicant.company.location.street}
            row(t('activerecord.attributes.location.zip.one')){applicant.company.location.zip}
            row(t('activerecord.attributes.location.city.one')){applicant.company.location.city}
            row(t('activerecord.attributes.location.region.one')){applicant.company.location.region}
            row(t('activerecord.attributes.location.country.one')){applicant.company.location.country}
          end
        end
      end   
    end
    panel t('active_admin.resource.event_registration') do
      table do
        tr do
          th t('activerecord.attributes.event.title')
          th t('activerecord.attributes.event_pricegroup.title.')
          th t('activerecord.attributes.event_pricegroup.price')
        end
        applicant.event_registrations.each do |ereg|
          tr do
            td ereg.event_pricegroup && ereg.event_pricegroup.event && ereg.event_pricegroup.event.title ? ereg.event_pricegroup.event.title : ""
            td ereg.event_pricegroup && ereg.event_pricegroup.title ? ereg.event_pricegroup.title : ""
            td ereg.event_pricegroup && ereg.event_pricegroup.price ? number_to_currency(ereg.event_pricegroup.price, :locale => :de) : ""
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
  
  member_action :send_conf_mail do
    reguser = GoldencobraEvents::RegistrationUser.find(params[:id])
    GoldencobraEvents::EventRegistrationMailer.registration_email(reguser).deliver unless Rails.env == "test"
    reguser.vita_steps << Goldencobra::Vita.create(:title => "Mail delivered: registration confirmation", :description => "email: #{reguser.email}, user: admin #{current_user.id}")
    redirect_to :action => :index, :notice => "Mail wurde versendet"
  end
  
  #GoldencobraEmailTemplates::EmailTemplate.all.each do |emailtemplate|
  #  batch_action "send_conf_mail_#{emailtemplate.id}", :confirm => "#{emailtemplate.title}: sind Sie sicher?" do |selection|
  #    GoldencobraEvents::RegistrationUser.find(selection).each do |reguser|
  #      GoldencobraEvents::EventRegistrationMailer.registration_email_with_template(reguser, emailtemplate).deliver unless Rails.env == "test"
  #      reguser.vita_steps << Goldencobra::Vita.create(:title => "Mail delivered: registration confirmation with template", :description => "email: #{reguser.email}, user: admin #{current_user.id}, email_template: #{emailtemplate.id}")
  #    end
  #    redirect_to :action => :index, :notice => "Mails wurden versendet"
  #  end
  #end
  
  batch_action :send_default_conf_mails, :confirm => "Sind Sie sicher?" do |selection|
    GoldencobraEvents::RegistrationUser.find(selection).each do |reguser|
      GoldencobraEvents::EventRegistrationMailer.registration_email(reguser).deliver unless Rails.env == "test"
      reguser.vita_steps << Goldencobra::Vita.create(:title => "Mail delivered: registration confirmation", :description => "email: #{reguser.email}, user: admin #{current_user.id}")
    end
    redirect_to :action => :index, :notice => "Mails wurden versendet"
  end
  
  controller do     
    def new       
      @applicant = GoldencobraEvents::RegistrationUser.new
      @applicant.company = GoldencobraEvents::Company.new
      @applicant.company.location = Goldencobra::Location.new
    end 
  end
  
end
