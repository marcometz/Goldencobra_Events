module GoldencobraEvents
  class Invoice < ActiveRecord::Base

    def self.invoice_number
      number = Goldencobra::Setting.for_key('goldencobra_events.invoice.last_invoice_number').to_i + 1
      Goldencobra::Setting.set_value_for_key(number.to_s, 'goldencobra_events.invoice.last_invoice_number')
      kuerzel = Goldencobra::Setting.for_key('goldencobra_events.invoice.event_name_for_invoice')
      s = "#{kuerzel}#{number}"
      s
    end

    def self.generate_invoice(registration_user)
      require 'pdfkit'
      invoice_numb = self.invoice_number
      html = ActionController::Base.new.render_to_string(template: 'templates/invoice/invoice', layout: false, locals: {user: registration_user, event: registration_user.event_registrations.first.event_pricegroup.event, invoice_number: invoice_numb})
      registration_user.event_registrations.first.update_attributes(invoice_number: invoice_numb)
      kit = PDFKit.new(html, :page_size => 'Letter')
      kit.to_file("#{Rails.root}/public/system/invoices/#{invoice_numb}.pdf")
    end
  end
end