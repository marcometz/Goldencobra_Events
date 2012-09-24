ActiveAdmin.register GoldencobraEvents::RegistrationUser, :as => "Invoice" do
  menu :parent => "Rechnungen", :label => "Abrechnungen", :if => proc{can?(:update, Goldencobra::Setting) && (Goldencobra::Setting.for_key('goldencobra_events.active_admin.menue.invoices.display') != "false")}
  controller.authorize_resource :class => GoldencobraEvents::RegistrationUser

  scope "Alle", :scoped, :default => true
  scope "Bezahlt", :payed
  scope "Unbezahlt", :unpayed
  scope "Rechnung nicht gestellt", :invoice_not_send
  scope "Aktive", :active
  scope "Stornierte", :storno

  filter :invoice_sent
  filter :payed_on
  filter :first_reminder_sent
  filter :second_reminder_sent
  filter :firstname
  filter :lastname
  filter :email
  filter :invoice_number
  filter :type_of_registration, :as => :select, :collection => GoldencobraEvents::RegistrationUser::RegistrationTypes
  filter :type_of_registration_not, :label => "Art der Registrierung ist NICHT", :as => :select, :collection => GoldencobraEvents::RegistrationUser::RegistrationTypes
  filter :total_price, :as => :numeric
  filter :active, :as => :select

  config.clear_action_items!
  action_item :only => [:show] do
    _invoice = @_assigns['invoice']
    link_to(t('active_admin.edit'), edit_admin_invoice_path(_invoice), :class => "member_link edit_link")
  end

  index do
    selectable_column
    column :firstname, :sortable => :firstname do |invoice|
      invoice.firstname
    end
    column :lastname, :sortable => :lastname do |invoice|
      invoice.lastname
    end
    column :total_price, sortable: :total_price do |u|
      number_to_currency(u.total_price, :locale => :de)
    end
    column "Rechnung" do |i|
      link_to(i.event_registrations.first.invoice_number, "/system/invoices/#{i.event_registrations.first.invoice_number}.pdf", target: "blank") if i.event_registrations.count > 0 && i.event_registrations.first.invoice_number.present?
    end
    column "Ticket" do |applicant|
      link_to(applicant.event_registrations.first.ticket_number, "/system/tickets/ticket_#{applicant.event_registrations.first.ticket_number}.pdf", target: "blank") if applicant.event_registrations.count > 0 && applicant.event_registrations.first.ticket_number.present?
    end
    column :invoice_sent, sortable: :invoice_sent do |invoice|
      invoice.invoice_sent.strftime("%d.%m.%Y") if invoice.invoice_sent
    end
    column :payed_on, sortable: :payed_on do |invoice|
      invoice.payed_on.strftime("%d.%m.%Y") if invoice.payed_on
    end
    column :first_reminder_sent, sortable: :first_reminder_sent do |invoice|
      invoice.first_reminder_sent.strftime("%d.%m.%Y") if invoice.first_reminder_sent
    end
    column :second_reminder_sent, sortable: :second_reminder_sent do |invoice|
      invoice.second_reminder_sent.strftime("%d.%m.%Y") if invoice.second_reminder_sent
    end
    column "" do |invoice|
      result = ""
      result += link_to(t('active_admin.view'), admin_invoice_path(invoice), :class => "member_link show_link")
      result += link_to(t('active_admin.edit'), edit_admin_invoice_path(invoice), :class => "member_link edit_link")
      raw(result)
    end
  end

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.actions
    f.inputs "Anmeldung" do
      f.input :type_of_registration, :as => :select, :collection => GoldencobraEvents::RegistrationUser::RegistrationTypes, :label => "Art der Anmeldung"
      f.input :comment, :label => "Kommentar", :input_html => {:rows => 3}
    end
    f.inputs "Historie" do
      f.has_many :vita_steps do |step|
        if step.object.new_record?
          step.input :description
        step.input :title, label: "Bearbeiter", hint: "Tragen Sie hier Ihren Namen ein, damit die Aktion zugeordnet werden kann"
        else
          step.input :description, :input_html => {:disabled => true, :resize => false, :class => "metadescription_hint", value: "#{step.object.title}; #{step.object.description}"}
        end
      end
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
    # end

    f.inputs "" do
      f.fields_for :company_attributes, f.object.company do |comp|
        comp.inputs "Firma", :class => "foldable inputs" do
          comp.input :title
          comp.input :legal_form
          comp.input :phone
          comp.input :fax
          comp.input :homepage
          comp.input :sector
          comp.input :id, as: :hidden
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
    f.actions
  end

  show :title => :lastname do
    panel t('activerecord.models.applicant', count: 1) do
      attributes_table_for invoice do
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
    panel t('activerecord.models.invoice', count: 1) do
      attributes_table_for invoice do
        row :invoice_sent
        row :payed_on
        row :first_reminder_sent
        row :second_reminder_sent
      end
    end
    panel t('activerecord.models.company', count: 1) do
      if invoice.company
          attributes_table_for invoice.company do
            row :title
            row :legal_form
            row :phone
            row :fax
            row :homepage
            row :sector
          end
        if invoice.company.location
          attributes_table_for invoice.company.location do
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
        invoice.event_registrations.each do |ereg|
          tr do
            td ereg.event_pricegroup && ereg.event_pricegroup.event && ereg.event_pricegroup.event.title ? ereg.event_pricegroup.event.title : ""
            td ereg.event_pricegroup && ereg.event_pricegroup.title ? ereg.event_pricegroup.title : ""
            td ereg.event_pricegroup && ereg.event_pricegroup.price ? number_to_currency(ereg.event_pricegroup.price, :locale => :de) : ""
          end
        end
        tr :class => "total" do
          td ""
          td "Summe:"
          td number_to_currency(invoice.total_price, :locale => :de)
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
        invoice.vita_steps.each do |vita|
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


  batch_action :destroy, false

  batch_action :generate_invoice do |selection|
    GoldencobraEvents::RegistrationUser.find(selection).each do |registration|
      #render(template: 'templates/invoice/invoice', layout: false, locals: {user: registration, event: registration.event_registrations.first.event_pricegroup.event.root})

      # Wenn Rechungen nicht mehrfach generiert werden sollen, dann die folgende Zeile entkommentieren und dafür die dahinter kommentieren
      # GoldencobraEvents::Invoice.generate_invoice(registration) if registration.event_registrations.any? && registration.event_registrations.first.invoice_number.blank?
      GoldencobraEvents::Invoice.generate_invoice(registration)
    end
    redirect_to action: :index
  end

  batch_action :generate_ticket do |selection|
    GoldencobraEvents::RegistrationUser.find(selection).each do |reguser|
      # render(template: 'templates/ticket/ticket', layout: false, locals: {user: reguser, event: reguser.event_registrations.first.event_pricegroup.event.root})

      # Wenn Tickets nicht mehrfach generiert werden sollen, dann die folgende Zeile entkommentieren und dafür die dahinter kommentieren
      # GoldencobraEvents::Ticket.generate_ticket(reguser.event_registrations.first) unless reguser.event_registrations.any? && reguser.event_registrations.first.ticket_number.present?
      GoldencobraEvents::Ticket.generate_ticket(reguser.event_registrations.first)
    end
    redirect_to :action => :index
  end

  sidebar "invoice_options", only: [:index] do
    render "/goldencobra_events/admin/invoices/invoice_options_sidebar"
  end

  collection_action :set_invoice_date, :method => :post do
    collection_selection = params[:invoice_collection_selection]
    if collection_selection.present?
      invoice_type = params[:invoice_type]
      GoldencobraEvents::RegistrationUser.find(collection_selection.split(",")).each do |reguser|
        reguser.send("#{invoice_type}=", params[:date])
        reguser.save
      end
    end
    flash[:notice] = "Datum wurde gesetzt"
    redirect_to :action => :index
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
    column :invoice_sent
    column :payed_on
    column :first_reminder_sent
    column :second_reminder_sent
  end
end
