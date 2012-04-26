ActiveAdmin.register GoldencobraEvents::RegistrationUser, :as => "Applicant" do
  menu :parent => "Event-Management", :label => "Besucher", :if => proc{can?(:read, GoldencobraEvents::RegistrationUser)}
  controller.authorize_resource :class => GoldencobraEvents::RegistrationUser

  filter :firstname, :label => "Vorname"
  filter :lastname, :label => "Nachname"
  filter :email, :label => "E-Mail"
  filter :type_of_registration, :label => "Art der Registrierung", :as => :select, :collection => GoldencobraEvents::RegistrationUser::RegistrationTypes
  filter :type_of_registration_not, :label => "Art der Registrierung ist NICHT", :as => :select, :collection => GoldencobraEvents::RegistrationUser::RegistrationTypes
  filter :total_price, :as => :numeric

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
    column "E-Mail erhalten am" do |user|
      user.last_email_send ? l(user.last_email_send, format: :short) : ""
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
    f.inputs "Rechnung" do
      f.input :invoice_sent, as: :string, :input_html => { class: "datepicker", :size => "20", value: "#{f.object.invoice_sent.strftime('%A, %d.%m.%Y') if f.object.invoice_sent}" }
      f.input :payed_on, as: :string, :input_html => { class: "datepicker", :size => "20", value: "#{f.object.payed_on.strftime('%A, %d.%m.%Y') if f.object.payed_on}" }
      f.input :first_reminder_sent, as: :string, :input_html => { class: "datepicker", :size => "20", value: "#{f.object.first_reminder_sent.strftime('%A, %d.%m.%Y') if f.object.first_reminder_sent}" }
      f.input :second_reminder_sent, as: :string, :input_html => { class: "datepicker", :size => "20", value: "#{f.object.second_reminder_sent.strftime('%A, %d.%m.%Y') if f.object.second_reminder_sent}" }
    end
    f.inputs "Besucher", :class => "foldable inputs" do
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
        comp.inputs "Firma", :class => "foldable inputs" do
          comp.input :title
          comp.input :legal_form 
          comp.input :phone      
          comp.input :fax        
          comp.input :homepage   
          comp.input :sector  
        end 
        comp.inputs "" do
          comp.fields_for :location_attributes, comp.object.location do |loc|
            loc.inputs "Adresse", :class => "foldable inputs" do
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
          th t('activerecord.attributes.event_pricegroup.title')
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
    panel t('active_admin.resource.vita') do
      table do
        tr do
          th t('activerecord.attributes.vita.title')
          th t('activerecord.attributes.vita.description')
          th t('activerecord.attributes.vita.created_at')
        end
        applicant.vita_steps.each do |vita|
          tr do
            td vita.title
            td vita.description
            td l(vita.created_at, format: :short)
          end
        end
      end
    end #end panel vita
  end
  
  
  if ActiveRecord::Base.connection.table_exists?("goldencobra_email_templates_email_templates")
    GoldencobraEmailTemplates::EmailTemplate.all.each do |emailtemplate|
      batch_action "send_mail_#{emailtemplate.title.parameterize.underscore}", :confirm => "#{emailtemplate.title}: sind Sie sicher?" do |selection|
        GoldencobraEvents::RegistrationUser.find(selection).each do |reguser|
          GoldencobraEvents::EventRegistrationMailer.registration_email_with_template(reguser, emailtemplate).deliver unless Rails.env == "test"
          reguser.vita_steps << Goldencobra::Vita.create(:title => "Mail delivered: registration confirmation", :description => "email: #{reguser.email}, user: admin #{current_user.id}, email_template: #{emailtemplate.id}")
        end
        redirect_to :action => :index, :notice => "Mails wurden versendet"
      end
    end
  end
  
  batch_action :send_default_conf_mails, :confirm => "Sind Sie sicher?" do |selection|
    GoldencobraEvents::RegistrationUser.find(selection).each do |reguser|
      GoldencobraEvents::EventRegistrationMailer.registration_email(reguser).deliver unless Rails.env == "test"
      reguser.vita_steps << Goldencobra::Vita.create(:title => "Mail delivered: registration confirmation", :description => "email: #{reguser.email}, user: admin #{current_user.id}")
    end
    redirect_to :action => :index, :notice => "Mails wurden versendet"
  end
  
  batch_action :destroy, false
  
  controller do  
           
    def new       
      ActiveAdmin.application.unload!
      ActiveAdmin.application.load!
      @applicant = GoldencobraEvents::RegistrationUser.new
      @applicant.company = GoldencobraEvents::Company.new
      @applicant.company.location = Goldencobra::Location.new
    end 
  end
  
  csv do
    column :id
    column :gender
    column :email
    column :title
    column :firstname
    column :lastname
    column :function
    column :phone
    column :agb
    column :type_of_registration
    column :created_at
    column :updated_at
    column :comment
    column("Company") {|applicant| applicant.company.title if applicant.company.present? }
    column("Street") {|applicant| applicant.company.location.street if applicant.company.present? && applicant.company.location.present? }
    column("City") {|applicant| applicant.company.location.city if applicant.company.present? && applicant.company.location.present? }
    column("ZIP") {|applicant| applicant.company.location.zip if applicant.company.present? && applicant.company.location.present? }
    column("Country") {|applicant| applicant.company.location.country if applicant.company.present? && applicant.company.location.present? }
    column("last_email_at") {|user| l(user.last_email_send, format: :short) if user.last_email_send.present? }
    column("total_price") {|u| number_to_currency(u.total_price, :locale => :de) }
    column("Preisgruppen") {|applicant| applicant.event_registrations.map(&:event_pricegroup).compact.map(&:title).uniq.compact.join(" - ") }
  end
  
end
