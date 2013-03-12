module GoldencobraEvents
  class Invoice < ActiveRecord::Base

    # Internal: Create the invoice number from a setting and iterates the
    # setting to the next invoice number. It also uses a short string for a
    # unique token at the beginning of the invoice number
    #
    # Takes no params
    #
    # Returns the invoice number as String
    def self.invoice_number
      number = Goldencobra::Setting.for_key('goldencobra_events.invoice.last_invoice_number', false).to_i + 1
      Goldencobra::Setting.set_value_for_key(number.to_s, 'goldencobra_events.invoice.last_invoice_number')
      kuerzel = Goldencobra::Setting.for_key('goldencobra_events.invoice.event_name_for_invoice')
      s = "#{kuerzel}#{number}"
      s
    end

    # Internal: Create the invoice as pdf file and saves it to disk. Saves the # invoice number as attribute to the event registration
    #
    # registration_user - The GoldencobraEvents::RegistrationUser for whom the #   invoice is intendend
    #
    # Returns nothing
    def self.generate_invoice(registration_user)
      require 'pdfkit'
      invoice_numb = self.invoice_number
      html = ActionController::Base.new.render_to_string(
                                    template: 'templates/invoice/invoice', layout: false,
                                      locals: {
          user: registration_user,
          event: registration_user.event_registrations.first.event_pricegroup.event,
          invoice_number: invoice_numb,
          invoice_date: registration_user.invoice_sent.present? ? registration_user.invoice_sent.strftime("%d.%m.%Y") : Time.now.strftime("%d.%m.%Y")
          })
      registration_user.event_registrations.first.update_attributes(invoice_number: invoice_numb)
      kit = PDFKit.new(html, :page_size => 'Letter')
      if !File.exists?("#{Rails.root}/public/system/invoices")
        Dir.mkdir("#{Rails.root}/public/system/invoices")
      end
      if File.exists?("#{Rails.root}/public/system/invoices/#{invoice_numb}.pdf")
        File.delete("#{Rails.root}/public/system/invoices/#{invoice_numb}.pdf")
      end
      kit.to_file("#{Rails.root}/public/system/invoices/#{invoice_numb}.pdf")
    end
  end
end