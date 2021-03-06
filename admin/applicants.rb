#encoding: utf-8

ActiveAdmin.register GoldencobraEvents::RegistrationUser, :as => "Applicant" do
  menu :parent => "Event-Management", :if => proc{can?(:read, GoldencobraEvents::RegistrationUser)}
  controller.authorize_resource :class => GoldencobraEvents::RegistrationUser

  scope "Aktive", :active, :default => true
  scope "Alle", :scoped
  scope "Stornierte", :storno
  scope "Aktive Events", :current_event

  filter :firstname
  filter :lastname
  filter :email
  filter :type_of_registration, :as => :select, :collection => GoldencobraEvents::RegistrationUser::RegistrationTypes
  filter :type_of_registration_not, :label => "Art der Registrierung ist NICHT", :as => :select, :collection => GoldencobraEvents::RegistrationUser::RegistrationTypes
  filter :total_price, :as => :numeric
  filter :active, :as => :select
  if ActiveRecord::Base.connection.table_exists?("goldencobra_events_pricegroups")
    filter :pricegroup_name, :as => :select, :collection => GoldencobraEvents::Pricegroup.pluck(:title)
  end

  index do
    selectable_column
    column :firstname, :sortable => :firstname do |applicant|
      applicant.firstname
    end
    column :lastname, :sortable => :lastname do |applicant|
      applicant.lastname
    end
    column :email, :sortable => :email do |applicant|
      span applicant.email, class: 'email'
    end
    column 'Ticket' do |applicant|
      link_to(applicant.master_event_registration.ticket_number, "/system/tickets/ticket_#{applicant.master_event_registration.ticket_number}.pdf", target: 'blank') if applicant.event_registrations.count > 0 && applicant.master_event_registration.ticket_number.present?
    end
    column '# Checkins' do |applicant|
      applicant.master_event_registration.checkin_count if applicant.event_registrations.any?
    end
    column :type_of_registration
    column :total_price, sortable: :total_price do |u|
      "#{number_to_currency(u.total_price, :locale => :de)} (#{u.pricegroup_title})"
    end
    column :last_email_send, sortable: :last_email_send do |user|
      user.last_email_send ? l(user.last_email_send, format: :short) : ''
    end
    column '' do |applicant|
      result = ''
      result += link_to(t('active_admin.view'), admin_applicant_path(applicant), class: 'member_link show_link')
      result += link_to(t('active_admin.edit'), edit_admin_applicant_path(applicant), class: 'member_link edit_link')
      result += link_to('Storno', deactivate_applicant_admin_applicant_path(applicant), class: 'member_link edit_link')
      raw(result)
    end
  end

  form :html => { :enctype => 'multipart/form-data' } do |f|
    if f.object.event_registrations.none?
      f.inputs "ACHTUNG" do
        p "Es gibt noch keine Anmeldungen fuer diesen Teilnehmer. Erstellen Sie unter 'Event-Anmeldungen' bitte die entsprechenden Anmeldungen mit Preisgruppen."
      end
    end
    f.actions

    f.inputs "Anmeldung", :class => "foldable inputs" do
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
          comp.fields_for :location_attributes, (comp.object.location if comp.object.present?) do |loc|
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

    f.inputs "Rechnungsadresse Ansprechpartner", class: "foldable inputs" do
      f.input :billing_gender, :as => :select, :collection => [["Herr", true],["Frau",false]], :include_blank => false
      f.input :billing_firstname
      f.input :billing_lastname
      f.input :billing_department, label: Goldencobra::Setting.for_key("goldencobra_events.event.registration.user_form.user_label.billing_department")
    end
    # if f.object.billing_company.present?
      f.inputs "Rechnungsadresse Firma" do
        f.fields_for :billing_company_attributes, f.object.billing_company do |comp|
          comp.inputs "", class: "foldable inputs" do
            comp.input :title
          end
          comp.inputs "" do
            comp.fields_for :location_attributes, (comp.object.location if comp.object.present?) do |loc|
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

    f.inputs "Anmeldung" do
      f.input :type_of_registration, :as => :select, :collection => GoldencobraEvents::RegistrationUser::RegistrationTypes, :label => "Art der Anmeldung"
      f.input :comment, :label => "Kommentar", :input_html => {:rows => 3}
    end
    f.inputs "Event-Anmeldungen" do
      f.has_many :event_registrations do |reg|
        reg.input :event_pricegroup_id, :as => :select, :collection => GoldencobraEvents::EventPricegroup.joins(:event).where(:goldencobra_events_events => {:active => true}).map{|a| ["#{a.event.title if a.event} (#{a.event.id if a.event}), #{a.pricegroup.title if a.pricegroup }, EUR:#{a.price}", a.id]}, :input_html => { :class => 'chzn-select', 'data-placeholder' => "Preisgruppe eines Events"}, label: t(:event_pricegroup, scope: [:activerecord, :models], count: 1)
        reg.input :_destroy, :as => :boolean
      end
    end
    f.inputs "Historie" do
      f.has_many :vita_steps do |step|
        if step.object.new_record?
          step.input :description, as: :string, label: "Eintrag"
          step.input :title, label: "Bearbeiter", hint: "Tragen Sie hier Ihren Namen ein, damit die Aktion zugeordnet werden kann"
        else
          render :partial => "/goldencobra_events/admin/applicants/vita_steps", :locals => {:step => step}
        end
      end
    end

    f.actions
    # if f.object.event_registrations.none?
    #   f.inputs "ACHTUNG" do
    #     p "Es gibt noch keine Anmeldungen fuer diesen Teilnehmer. Erstellen Sie unter 'Event-Anmeldungen' bitte die entsprechenden Anmeldungen mit Preisgruppen."
    #   end
    # end
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

  # if ActiveRecord::Base.connection.table_exists?("goldencobra_email_templates_email_templates")
  #   GoldencobraEmailTemplates::EmailTemplate.all.each do |emailtemplate|
  #     batch_action "send_mail_#{emailtemplate.title.parameterize.underscore}", :confirm => "#{emailtemplate.title}: sind Sie sicher?" do |selection|
  #       GoldencobraEvents::RegistrationUser.find(selection).each do |reguser|
  #         GoldencobraEvents::EventRegistrationMailer.registration_email_with_template(reguser, emailtemplate).deliver unless Rails.env == "test"
  #         reguser.vita_steps << Goldencobra::Vita.create(:title => "Mail delivered: registration confirmation", :description => "email: #{reguser.email}, user: admin #{current_user.id}, email_template: #{emailtemplate.id}")
  #         reguser.user.vita_steps << Goldencobra::Vita.create(:title => "Mail delivered: registration confirmation", :description => "email: #{reguser.email}, user: admin #{current_user.id}")
  #       end
  #       flash[:notice] = "Mails wurden versendet"
  #       redirect_to :action => :index
  #     end
  #   end
  # end

  batch_action "Sende Bestätigungsemail", :confirm => "Sind Sie sicher?" do |selection|
    GoldencobraEvents::RegistrationUser.find(selection).each do |reguser|
      # Ticket generieren, sofern noch nicht vorhanden
      if reguser.event_registrations.any? && reguser.master_event_registration.ticket_number.blank?
        GoldencobraEvents::Ticket.generate_ticket(reguser.master_event_registration)
      end
      GoldencobraEvents::EventRegistrationMailer.registration_email(reguser).deliver unless Rails.env == "test"
      reguser.vita_steps << Goldencobra::Vita.create(:title => "Mail delivered: registration confirmation", :description => "email: #{reguser.email}, user: admin #{current_user.id}")
      reguser.user.vita_steps << Goldencobra::Vita.create(:title => "Mail delivered: registration confirmation", :description => "email: #{reguser.email}, user: admin #{current_user.id}")
    end
    flash[:notice] = "Mails wurden versendet"
    redirect_to :action => :index
  end

  batch_action "Storniere Anmeldung", :confirm => "Sie wollen diese Gaeste stornieren?" do |selection|
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
    flash[:notice] = t("inactive", :scope => [:active_admin, :flash_notice])
    redirect_to :action => :show
  end

  member_action :reactivate_applicant do
    reguser = GoldencobraEvents::RegistrationUser.find(params[:id])
    reguser.reactivate_reservation!
    flash[:notice] = t("active", :scope => [:active_admin, :flash_notice])
    redirect_to :action => :show
  end

  if ActiveRecord::Base.connection.table_exists?("goldencobra_newsletter_newsletter_registrations")
    # Search for NewsletterRegistrations. If present, MasterData ist registered as ActiveAdmin resource as well
    action_item only: [:edit, :show] do
      _applicant = @_assigns['applicant']
      link_to t(:link_to_master_data, scope: [:active_admin, :applicants]), edit_admin_master_datum_path(_applicant.user_id) if _applicant.user_id.present?
    end
  end

  action_item :only => [:edit, :show] do
    _applicant = @_assigns['applicant']
    if _applicant.active
      link_to('Diesen Gast stornieren', deactivate_applicant_admin_applicant_path(_applicant))
    else
      link_to('Diesen Gast wieder reaktivieren', reactivate_applicant_admin_applicant_path(_applicant))
    end
  end

  action_item only: [:edit, :show] do
    render partial: '/goldencobra/admin/shared/prev_item'
  end

  action_item only: [:edit, :show] do
    render partial: '/goldencobra/admin/shared/next_item'
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
