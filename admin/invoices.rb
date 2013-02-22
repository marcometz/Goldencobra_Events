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
      link_to(i.event_registrations.first.invoice_number, "/system/invoices/#{i.event_registrations.first.invoice_number}.pdf?#{Time.now}", target: "blank") if i.event_registrations.count > 0 && i.event_registrations.first.invoice_number.present?
    end
    column "Ticket" do |invoice|
      link_to(invoice.event_registrations.first.ticket_number, "/system/tickets/ticket_#{invoice.event_registrations.first.ticket_number}.pdf?#{Time.now}", target: "blank") if invoice.event_registrations.count > 0 && invoice.event_registrations.first.ticket_number.present?
    end
    column '# Checkins' do |invoice|
      invoice.event_registrations.first.checkin_count if invoice.event_registrations.any?
    end
    column :invoice_sent, sortable: :invoice_sent do |invoice|
      invoice.invoice_sent.strftime("%d.%m.%Y") if invoice.invoice_sent
    end
    column :payed_on, sortable: :payed_on do |invoice|
      invoice.payed_on.strftime("%d.%m.%Y") if invoice.payed_on.present?
    end
    column :first_reminder_sent, sortable: :first_reminder_sent do |invoice|
      if invoice.first_reminder_sent.present?
        invoice.first_reminder_sent.strftime("%d.%m.%Y")
      end
    end
    column :second_reminder_sent, sortable: :second_reminder_sent do |invoice|
      if invoice.second_reminder_sent.present?
        invoice.second_reminder_sent.strftime("%d.%m.%Y")
      end
    end
    column 'Storno' do |i|
      vita_step = i.vita_steps.where(title: 'Registration canceled').last
      if vita_step && !i.active && i.event_registrations.any? && i.event_registrations.first.invoice_number.present?
        if File.exists?("#{Rails.root}/public/system/invoices/cancellation_#{i.event_registrations.first.invoice_number}.pdf")
          link_to(vita_step.created_at.strftime("%d.%m.%Y"), "/system/invoices/cancellation_#{i.event_registrations.first.invoice_number}.pdf?#{Time.now}", target: "blank")
        else
          vita_step.created_at.strftime("%d.%m.%Y")
        end
      else
        ''
      end
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
          step.input :description, as: :string, label: "Eintrag"
          step.input :title, label: "Bearbeiter", hint: "Tragen Sie hier Ihren Namen ein, damit die Aktion zugeordnet werden kann"
        else
          render :partial => "/goldencobra/admin/users/vita_steps", :locals => {:step => step}
        end
      end
    end
    f.inputs "Rechnung" do
      f.input :invoice_sent, as: :string, :input_html => { class: "datepicker", :size => "20", value: "#{f.object.invoice_sent.strftime('%A, %d.%m.%Y') if f.object.invoice_sent}" }
      f.input :payed_on, as: :string, :input_html => { class: "datepicker", :size => "20", value: "#{f.object.payed_on.strftime('%A, %d.%m.%Y') if f.object.payed_on}" }
      f.input :first_reminder_sent, as: :string, :input_html => { class: "datepicker", :size => "20", value: "#{f.object.first_reminder_sent.strftime('%A, %d.%m.%Y') if f.object.first_reminder_sent}" }
      f.input :second_reminder_sent, as: :string, :input_html => { class: "datepicker", :size => "20", value: "#{f.object.second_reminder_sent.strftime('%A, %d.%m.%Y') if f.object.second_reminder_sent}" }
    end
    f.inputs "Anmeldung", :class => "foldable inputs" do
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
          reguser.user.vita_steps << Goldencobra::Vita.create(:title => "Mail delivered: registration confirmation", :description => "email: #{reguser.email}, user: admin #{current_user.id}, email_template: #{emailtemplate.id}")
        end
        flash[:notice] = "Mails wurden versendet"
        redirect_to :action => :index
      end
    end
  end

  batch_action :destroy, false


  batch_action :generate_ticket do |selection|
    GoldencobraEvents::RegistrationUser.find(selection).each do |reguser|
      # render(template: 'templates/ticket/ticket', layout: false, locals: {user: reguser, event: reguser.event_registrations.first.event_pricegroup.event.root})

      # Wenn Tickets nicht mehrfach generiert werden sollen, dann die folgende Zeile entkommentieren und dafür die dahinter kommentieren
      # GoldencobraEvents::Ticket.generate_ticket(reguser.event_registrations.first) unless reguser.event_registrations.any? && reguser.event_registrations.first.ticket_number.present?

      reguser.vita_steps << Goldencobra::Vita.create(:title => "Ticket erstellt", :description => "von #{current_user.email}")
      send_file(GoldencobraEvents::Ticket.generate_ticket(reguser.event_registrations.last), :type => 'application/pdf', :disposition => 'attachement')
    end
    # redirect_to :action => :index
  end

  batch_action :generate_invoice do |selection|
    @generated = false
    GoldencobraEvents::RegistrationUser.find(selection).each do |reguser|
      if reguser.event_registrations.any? && reguser.event_registrations.last.event_pricegroup.price > 0.0
        @generated = true
        reguser.set_invoice_date(Date.today) unless reguser.invoice_sent.present?
        pdf_invoice = GoldencobraEvents::Invoice.generate_invoice(reguser)
        reguser.vita_steps << Goldencobra::Vita.create(:title => "Rechnung erstellt", :description => "von #{current_user.email}")
        if Goldencobra::Setting.for_key('goldencobra_events.printer.email') != 'test@test.de'
          GoldencobraEvents::SentToPrinterMailer.send_email(pdf_invoice).deliver
        end

        require 'pixelletter'
        Pixelletter.load_initial_values unless ENV['EMAIL'].present?

        if Goldencobra::Setting.for_key('goldencobra_events.send_with_pixelletter') == 'true' && ENV['EMAIL'].present?
          testmode = Goldencobra::Setting.for_key('goldencobra_events.pixelletter_testmodus') == 'true' ? true : false
          request = Pixelletter::Request.new(email: ENV['EMAIL'], password: ENV['PASSWORD'], agb: true, widerrufsverzicht: true, testmodus: testmode)
          order = { order: { options: { type: 'upload', action: 1, destination: 'DE' } } }
          response = request.request(order, pdf_invoice)
          reguser.vita_steps << Goldencobra::Vita.create(:title => "Rechnung an Pixelletter gesandt", :description => "von #{current_user.email}")
        end
        # Do not download file
        # file = File.new(File.join(Rails.root, 'public', 'system', 'invoices', "#{reguser.event_registrations.last.invoice_number}.pdf"))
        # send_file(file, :type => 'application/pdf', :disposition => 'attachement')
      end
    end
    redirect_to :action => :index unless @generated
  end

  batch_action :generate_cancellation do |selection|
    @generated = false
    GoldencobraEvents::RegistrationUser.find(selection).each do |reguser|
      if reguser.event_registrations.any? && reguser.event_registrations.last.event_pricegroup.price > 0.0
        @generated = true
        cancelation_file = reguser.generate_cancellation
        reguser.cancel_reservation! # Erstellt VitaStep und verschickt email
        if Goldencobra::Setting.for_key('goldencobra_events.printer.email') != 'test@test.de'
          GoldencobraEvents::SentToPrinterMailer.send_email(cancelation_file).deliver
        end

        require 'pixelletter'
        Pixelletter.load_initial_values unless ENV['EMAIL'].present?

        if Goldencobra::Setting.for_key('goldencobra_events.send_with_pixelletter') == 'true' && ENV['EMAIL'].present?
          testmode = Goldencobra::Setting.for_key('goldencobra_events.pixelletter_testmodus') == 'true' ? true : false
          request = Pixelletter::Request.new(email: ENV['EMAIL'], password: ENV['PASSWORD'], agb: true, widerrufsverzicht: true, testmodus: testmode)
          order = { order: { options: { type: 'upload', action: 1, destination: 'DE' } } }
          response = request.request(order, cancelation_file)
          reguser.vita_steps << Goldencobra::Vita.create(:title => "Storno an Pixelletter gesandt", :description => "von #{current_user.email}")
        end
        # Do not download file
        # file = File.new(File.join(Rails.root, 'public', 'system', 'invoices', "cancellation_#{reguser.event_registrations.last.invoice_number}.pdf"))
        # send_file(file, :type => 'application/pdf', :disposition => 'attachement')
      end
    end
    redirect_to :action => :index unless @generated
  end

  batch_action :generate_reminder_1 do |selection|
    @generated = false
    GoldencobraEvents::RegistrationUser.find(selection).each do |reguser|
      if reguser.event_registrations.any? && reguser.event_registrations.last.event_pricegroup.price > 0.0
        @generated = true
        reguser.vita_steps << Goldencobra::Vita.create(:title => "Mahnung 1 erstellt", :description => "von #{current_user.email}")
        reminder_1_file = reguser.generate_reminder(1)
        reguser.update_attributes(first_reminder_sent: Date.today)
        if Goldencobra::Setting.for_key('goldencobra_events.printer.email') != 'test@test.de'
          GoldencobraEvents::SentToPrinterMailer.send_email(reminder_1_file).deliver
        end

        require 'pixelletter'
        Pixelletter.load_initial_values unless ENV['EMAIL'].present?

        if Goldencobra::Setting.for_key('goldencobra_events.send_with_pixelletter') == 'true' && ENV['EMAIL'].present?
          testmode = Goldencobra::Setting.for_key('goldencobra_events.pixelletter_testmodus') == 'true' ? true : false
          request = Pixelletter::Request.new(email: ENV['EMAIL'], password: ENV['PASSWORD'], agb: true, widerrufsverzicht: true, testmodus: testmode)
          order = { order: { options: { type: 'upload', action: 1, destination: 'DE' } } }
          response = request.request(order, reminder_1_file)
          reguser.vita_steps << Goldencobra::Vita.create(:title => "Mahnung 1 an Pixelletter gesandt", :description => "von #{current_user.email}")
        end
        # Do not download file
        # file = File.new(File.join(Rails.root, 'public', 'system', 'invoices', "reminder_1_#{reguser.event_registrations.last.invoice_number}.pdf"))
        # send_file(file, :type => 'application/pdf', :disposition => 'attachement')
      end
    end
    redirect_to :action => :index unless @generated
  end

  batch_action :generate_reminder_2 do |selection|
    @generated = false
    GoldencobraEvents::RegistrationUser.find(selection).each do |reguser|
      if reguser.event_registrations.any? && reguser.event_registrations.last.event_pricegroup.price > 0.0
        @generated = true
        reguser.vita_steps << Goldencobra::Vita.create(:title => "Mahnung 2 erstellt", :description => "von #{current_user.email}")

        reminder_2_file = reguser.generate_reminder(2)
        reguser.update_attributes(second_reminder_sent: Date.today)

        if Goldencobra::Setting.for_key('goldencobra_events.printer.email') != 'test@test.de'
          GoldencobraEvents::SentToPrinterMailer.send_email(reminder_2_file).deliver
        end
        require 'pixelletter'
        Pixelletter.load_initial_values unless ENV['EMAIL'].present?

        if Goldencobra::Setting.for_key('goldencobra_events.send_with_pixelletter') == 'true' && ENV['EMAIL'].present?
          testmode = Goldencobra::Setting.for_key('goldencobra_events.pixelletter_testmodus') == 'true' ? true : false
          request = Pixelletter::Request.new(email: ENV['EMAIL'], password: ENV['PASSWORD'], agb: true, widerrufsverzicht: true, testmodus: testmode)
          order = { order: { options: { type: 'upload', action: 1, destination: 'DE' } } }
          response = request.request(order, reminder_2_file)
          reguser.vita_steps << Goldencobra::Vita.create(:title => "Mahnung 2 an Pixelletter gesandt", :description => "von #{current_user.email}")
        end
        # Do not download file
        # file = File.new(File.join(Rails.root, 'public', 'system', 'invoices', "reminder_2_#{reguser.event_registrations.last.invoice_number}.pdf"))
        # send_file(file, :type => 'application/pdf', :disposition => 'attachement')
      end
    end
    redirect_to :action => :index unless @generated
  end

  sidebar "invoice_options", only: [:index] do
    render "/goldencobra_events/admin/invoices/invoice_options_sidebar"
  end

  action_item only: [:edit, :show] do
    render partial: '/goldencobra/admin/shared/prev_item'
  end

  action_item only: [:edit, :show] do
    render partial: '/goldencobra/admin/shared/next_item'
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
    # column("Company") {|applicant| applicant.billing_company.firstname.present? ? applicant.billing_company.firstname : applicant.company.firstname }
    # column("Street") {|applicant| applicant.billing_company.firstname.present? && applicant.billing_company.location.present? ? applicant.billing_company.location.street : applicant.company.location.street }
    # column("City") {|applicant| applicant.billing_company.firstname.present? && applicant.billing_company.location.present? ? applicant.billing_company.location.city : applicant.company.location.city }
    # column("ZIP") {|applicant| applicant.billing_company.firstname.present? && applicant.billing_company.location.present? ? applicant.billing_company.location.zip : applicant.company.location.zip }
    # column("Country") {|applicant| applicant.billing_company.firstname.present? && applicant.billing_company.location.present? ? applicant.billing_company.location.country : applicant.company.location.country }
    column("last_email_at") {|user| l(user.last_email_send, format: :short) if user.last_email_send.present? }
    column("total_price") {|u| number_to_currency(u.total_price, :locale => :de) }
    column("Preisgruppen") {|applicant| applicant.event_registrations.map(&:event_pricegroup).compact.map(&:title).uniq.compact.join(" - ") }
    column :invoice_sent
    column :payed_on
    column :first_reminder_sent
    column :second_reminder_sent
  end
end
