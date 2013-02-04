require 'spec_helper'

describe '/goldencobra_events/admin/tickets/_barcode_scan' do
  it 'should list already scanned tickets in a small table' do
    create :event_registration, ticket_number: 'ticket_123'
    create :event_registration, ticket_number: 'ticket_124'
    create :event_registration, ticket_number: 'ticket_125'

    render :partial => "/goldencobra_events/admin/tickets/barcode_scan"

    rendered.should have_content("ticket_123")
    rendered.should have_content("ticket_124")
    rendered.should have_content("ticket_125")
  end

  it "should display a ticket's user and her details" do
    user = create :registration_user, email: 'tim@test.de', firstname: 'Tim', lastname: 'Test'
    create :event_registration, ticket_number: 'ticket_123', user_id: GoldencobraEvents::RegistrationUser.first.id

    render :partial => "/goldencobra_events/admin/tickets/barcode_scan"

    rendered.should have_content("Tim Test, tim@test.de")
  end

  it "should display a checkin time" do
    ticket = create :event_registration, ticket_number: 'ticket_125'

    render :partial => "/goldencobra_events/admin/tickets/barcode_scan"

    rendered.should have_content("Check-In Zeit: #{ticket.updated_at.strftime('%H:%M Uhr, am %d.%m.%y')}")
  end
end