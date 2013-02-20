ActiveAdmin.register GoldencobraEvents::Ticket, :as => "Tickets scannen" do
  menu :parent => "Event-Management", :if => proc{can?(:read, GoldencobraEvents::RegistrationUser)}

  skip_before_filter :verify_authenticity_token

  # before_filter { @skip_sidebar = true }
  before_filter { GoldencobraEvents::Ticket.all.none? ? GoldencobraEvents::Ticket.create : nil }
  batch_action :destroy, false


  config.clear_action_items!

  index do
    div do
      render "/goldencobra_events/admin/tickets/barcode_scan"
    end
  end

  collection_action :verify_barcode, method: :post do
    input = params[:input]
    if input
      if input =~ /(ticket\?){1}\d+/
        registration = GoldencobraEvents::EventRegistration.active.where('ticket_number = ? AND ticket_number IS NOT NULL', input.to_s.split("?")[1]).readonly(false).first
        via_barcode = true
      else
        via_barcode = false
        registration = GoldencobraEvents::RegistrationUser.search_with_indifferent_attributes(input)
      end
    end

    @count = 0
    if via_barcode && registration && registration.count == 1
      @barcode = "valid"
      @checkin = registration.checkin_status_message
      @count = registration.checkin_count
    elsif registration && registration.count > 1
      logger.info "\n\n\ntest\n"
      @barcode = false
      @hits = registration
    else
      @hits = []
      @barcode = false
    end
    respond_to do |format|
      format.js { render file: "goldencobra_events/admin/tickets/verify_barcode"}
    end
  end

  collection_action :check_in, method: :get do
    if params[:reg_id].present?
      ev_reg = GoldencobraEvents::EventRegistration.active.where(user_id: params[:reg_id]).readonly(false).first
    end

    if ev_reg
      @checkin = ev_reg.checkin_status_message
      @count = ev_reg.checkin_count
      @barcode = "valid"
    end
    respond_to do |format|
      format.js { render file: "goldencobra_events/admin/tickets/verify_barcode"}
    end
  end
end
