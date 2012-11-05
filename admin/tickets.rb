ActiveAdmin.register GoldencobraEvents::Ticket, :as => "Tickets scannen" do
  menu :parent => "Event-Management", :if => proc{can?(:read, GoldencobraEvents::RegistrationUser)}

  skip_before_filter :verify_authenticity_token

  before_filter { @skip_sidebar = true }
  before_filter { GoldencobraEvents::Ticket.all.none? ? GoldencobraEvents::Ticket.create : nil }
  batch_action :destroy, false


  config.clear_action_items!

  index do
    div do
      render "/goldencobra_events/admin/tickets/barcode_scan"
    end
  end

  collection_action :verify_barcode, method: :post do
    barcode = params[:barcode]
    registration = GoldencobraEvents::EventRegistration.active.where(ticket_number: barcode.to_s.split("?")[1]).readonly(false).first
    if registration
      @barcode = "valid"
      @checkin = registration.checkin_status_message
    else
      @barcode = false
    end
    respond_to do |format|
      format.js { render file: "goldencobra_events/admin/tickets/verify_barcode"}
    end
  end
end