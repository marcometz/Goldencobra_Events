module GoldencobraEvents
  class Ticket < ActiveRecord::Base
    def self.generate_barcode
      require 'barby'
      require 'barby/barcode/code_128'
      require 'barby/outputter/ascii_outputter'
      require 'barby/outputter/png_outputter'

      ticket_number = self.next_ticket_number.to_s
      barcode = Barby::Code128B.new("ticket_#{ticket_number}")
      File.open("#{Rails.root}/public/system/tickets/barcode_for_ticket_#{ticket_number}.png", 'w'){|f|
        f.write barcode.to_png(:height => 30, :margin => 5)
      }
      ticket_number
    end

    def self.generate_ticket(event_registration)
      require 'pdfkit'
      ticket_number = self.generate_barcode
      html = ActionController::Base.new.render_to_string(template: 'templates/ticket/ticket', layout: false, locals: {user: event_registration.user, event: event_registration.event_pricegroup.event, ticket_number: ticket_number})
      event_registration.update_attributes(ticket_number: ticket_number)
      kit = PDFKit.new(html, :page_size => 'Letter')
      kit.to_file("#{Rails.root}/public/system/tickets/ticket_#{ticket_number}.pdf")
    end

    private

    def self.next_ticket_number
      number = Goldencobra::Setting.for_key('goldencobra_events.ticket.last_ticket_number').to_i + 1
      Goldencobra::Setting.set_value_for_key(number.to_s, 'goldencobra_events.ticket.last_ticket_number')
      number
    end
  end
end
