ActiveAdmin.register GoldencobraEvents::RegistrationUser, :as => "Applicant" do
  menu :parent => "Event-Management", :if => proc{can?(:read, GoldencobraEvents::RegistrationUser)}
  controller.authorize_resource :class => GoldencobraEvents::RegistrationUser

  scope "Alle", :scoped, :default => true
  scope "Aktive", :active
  scope "Stornierte", :storno

  filter :firstname
  filter :lastname
  filter :email
  filter :type_of_registration, :as => :select, :collection => GoldencobraEvents::RegistrationUser::RegistrationTypes
  filter :type_of_registration_not, :label => "Art der Registrierung ist NICHT", :as => :select, :collection => GoldencobraEvents::RegistrationUser::RegistrationTypes
  filter :total_price, :as => :numeric
  filter :active, :as => :select

  index do
    selectable_column
    column :firstname, :sortable => :firstname do |applicant|
      applicant.firstname
    end
    column :lastname, :sortable => :lastname do |applicant|
      applicant.lastname
    end
    column :email, :sortable => :email do |applicant|
      span applicant.email, class: "email"
    end
    column :type_of_registration
    column :total_price do |u|
      number_to_currency(u.total_price, :locale => :de)
    end
    column :last_email_send do |user|
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
    f.inputs "Besucher", :class => "foldable inputs" do
      f.input :gender, :as => :select, :collection => [["Herr", true],["Frau",false]], :include_blank => false
      f.input :email
      f.input :title
      f.input :firstname
      f.input :lastname
      f.input :function
      f.input :phone
      if f.object.agb == true
        f.input :agb, :label => "AGB akzeptiert", :input_html => { :checked => 'checked' }
      else
        f.input :agb, :label => "AGB akzeptiert"
      end
    end

    f.inputs "Rechnungsadresse Ansprechpartner", class: "foldable inputs" do
      f.input :billing_gender, :as => :select, :collection => [["Herr", true],["Frau",false]], :include_blank => false
      f.input :billing_firstname
      f.input :billing_lastname
      f.input :billing_department, label: Goldencobra::Setting.for_key("goldencobra_events.event.registration.user_form.user_label.billing_department")
    end
    f.inputs "Rechnungsadresse Firma" do
      f.fields_for :billing_company_attributes, f.object.billing_company do |comp|
        comp.inputs "", class: "foldable inputs" do
          comp.input :title
        end
        comp.inputs "" do
          comp.fields_for :location_attributes, f.object.billing_company.location do |loc|
            loc.inputs "Anschrift", :class => "foldable inputs" do
              loc.input :street
              loc.input :city
              loc.input :zip
              loc.input :country, :as => :string
            end
          end
        end
      end
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
            loc.inputs "#{t('location', scope: [:activerecord, :models], count: 1)}", :class => "foldable inputs" do
              loc.input :street
              loc.input :city
              loc.input :zip
              loc.input :region
              loc.input :country, :as => :string
            end
          end
        end
      end
    end
    f.inputs "" do
      f.has_many :event_registrations do |reg|
        reg.input :event_pricegroup_id, :as => :select, :collection => GoldencobraEvents::EventPricegroup.joins(:event).map{|a| ["#{a.event.title if a.event} (#{a.event.id if a.event}), #{a.pricegroup.title if a.pricegroup }, EUR:#{a.price}", a.id]}, :input_html => { :class => 'chzn-select', 'data-placeholder' => "Preisgruppe eines Events"}, label: t(:event_pricegroup, scope: [:activerecord, :models], count: 1)
        reg.input :_destroy, :as => :boolean 
      end
    end
    f.inputs :class => "buttons inputs" do
      f.actions
    end
  end

  show :title => :lastname do
    panel t('activerecord.models.applicant', count: 1) do
      attributes_table_for applicant do
        row :firstname
        row :lastname
        row :title
        row :gender
        row :function
        row :phone
        row :created_at
        row :updated_at
      end
    end #end panel applicant
    panel t('activerecord.models.company', count: 1) do
      if applicant.company
          attributes_table_for applicant.company do
            row :title
            row :legal_form
            row :phone
            row :fax
            row :homepage
            row :sector
          end
        if applicant.company.location 
          attributes_table_for applicant.company.location do
            row :street
            row :zip
            row :city
            row :region
            row :country
          end
        end
      end   
    end
    panel t('activerecord.models.event_registration', count: 3) do
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
    panel "Vita" do
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
        flash[:notice] = "Mails wurden versendet"
        redirect_to :action => :index
      end
    end
  end
  
  batch_action :send_default_conf_mails, :confirm => "Sind Sie sicher?" do |selection|
    GoldencobraEvents::RegistrationUser.find(selection).each do |reguser|
      GoldencobraEvents::EventRegistrationMailer.registration_email(reguser).deliver unless Rails.env == "test"
      reguser.vita_steps << Goldencobra::Vita.create(:title => "Mail delivered: registration confirmation", :description => "email: #{reguser.email}, user: admin #{current_user.id}")
    end
    flash[:notice] = "Mails wurden versendet"
    redirect_to :action => :index
  end
  
  batch_action :deactivate_applicants, :confirm => "Sie wollen diese Gaeste stornieren?" do |selection|
    GoldencobraEvents::RegistrationUser.find(selection).each do |reguser|
      reguser.cancel_reservation!
    end
    flash[:notice] = "Gaeste wurden deaktiviert"
    redirect_to :action => :index
  end
  
  batch_action :destroy, false
  
  member_action :deactivate_applicant do
    reguser = GoldencobraEvents::RegistrationUser.find(params[:id])
    reguser.cancel_reservation!
    flash[:notice] = "This Applicant is now inactive!"
    redirect_to :action => :show
  end

  member_action :reactivate_applicant do
    reguser = GoldencobraEvents::RegistrationUser.find(params[:id])
    reguser.reactivate_reservation!
    flash[:notice] = "This Applicant is now active!"
    redirect_to :action => :show
  end

  
  action_item :only => [:edit, :show] do
    _applicant = @_assigns['applicant']
    if _applicant.active
      link_to('Diesen Gast stornieren', deactivate_applicant_admin_applicant_path(_applicant))
    else
      link_to('Diesen Gast wieder reaktivieren', reactivate_applicant_admin_applicant_path(_applicant))
    end
  end
  
  controller do  
           
    def new       
      @applicant = GoldencobraEvents::RegistrationUser.new
      @applicant.company = GoldencobraEvents::Company.new
      @applicant.company.location = Goldencobra::Location.new
    end 
  end
  
  csv do
    column :id
    column :active
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
    column("Rechnungs-Firma Name") {|applicant| applicant.billing_company.title if applicant.billing_company.present? }
    column("Rechnungs-Firma Strasse") {|applicant| applicant.billing_company.location.street if applicant.billing_company.present? && applicant.billing_company.location.present? }
    column("Rechnungs-Firma Stadt") {|applicant| applicant.billing_company.location.city if applicant.billing_company.present? && applicant.billing_company.location.present? }
    column("Rechnugns-Firma PLZ") {|applicant| applicant.billing_company.location.zip if applicant.billing_company.present? && applicant.billing_company.location.present? }
    column("Rechunungs-Firma Land") {|applicant| applicant.billing_company.location.country if applicant.billing_company.present? && applicant.billing_company.location.present? }
  end
  
end
