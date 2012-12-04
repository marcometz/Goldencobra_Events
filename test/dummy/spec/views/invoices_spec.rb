require 'spec_helper'

describe "Generating documents" do
  before do
    event = GoldencobraEvents::Event.create(title: 'Test', start_date: Time.now - 5.days)
    pricegroup = GoldencobraEvents::Pricegroup.create(title: 'Preisgruppe')
    event_pricegroup = GoldencobraEvents::EventPricegroup.create(event_id: event.id, pricegroup_id: pricegroup.id)
    location = Goldencobra::Location.create(street: 'Zossener Str. 55',
                                            zip: '10961',
                                            city: 'Berlin')
    company = GoldencobraEvents::Company.create(title: "Privatunternehmen",
                                                location_id: location.id)

    billing_location = Goldencobra::Location.create(street: 'Musterstr. 1',
                                            zip: '12345',
                                            city: 'Berlin')
    billing_company = GoldencobraEvents::Company.create(title: "Mustercompany",
                                                location_id: billing_location.id)

    @reg_user = GoldencobraEvents::RegistrationUser.create(firstname: 'Tim',
                                                          lastname: 'Test',
                                                          email: 'tim@test.de',
                                                          gender: true,
                                                          company_id: company.id,
                                                          billing_company_id: billing_company.id,
                                                          should_not_initialize: true)

    privatperson = GoldencobraEvents::Company.create(title: "privat Person",
                                                     location_id: location.id)

    @privat_user = GoldencobraEvents::RegistrationUser.create(firstname: 'Tim',
                                                          lastname: 'Test',
                                                          email: 'tim@test.de',
                                                          gender: true,
                                                          company_id: company.id,
                                                          should_not_initialize: true)

    GoldencobraEvents::EventRegistration.create(user_id: @reg_user.id,
                                                event_pricegroup_id: event_pricegroup.id)
    GoldencobraEvents::EventRegistration.create(user_id: @privat_user.id,
                                                event_pricegroup_id: event_pricegroup.id)
  end

  it 'should generate a valid invoice' do
    render(template: 'templates/invoice/invoice',
           layout: nil,
           locals: {
            user: @reg_user,
            event: @reg_user.event_registrations.first.event_pricegroup.event,
            invoice_number: "Test-123",
            invoice_date: Time.now.strftime("%d.%m.%Y")})
    rendered.should have_content('Mustercompany')
    rendered.should have_content('Musterstr. 1')
    rendered.should have_content('12345 Berlin')
  end

  it 'should generate a ticket without the billing company' do
    render(template: 'templates/ticket/ticket',
           layout: nil,
           locals: {
             user: @reg_user,
             event: @reg_user.event_registrations.first.event_pricegroup.event.root,
             ticket_number: 'Ticket-123'})
    rendered.should have_content('Privatunternehmen')
    rendered.should have_content('Zossener Str. 55')
    rendered.should have_content('10961 Berlin')
  end

  it 'should generate a ticket without the privatPerson' do
    render(template: 'templates/invoice/invoice',
           layout: nil,
           locals: {
            user: @privat_user,
            event: @privat_user.event_registrations.first.event_pricegroup.event,
            invoice_number: "Test-123",
            invoice_date: Time.now.strftime("%d.%m.%Y")})
    rendered.should_not have_content('privat Person')
    rendered.should have_content('Zossener Str. 55')
    rendered.should have_content('10961 Berlin')
  end

  it 'should generate a ticket without the privatPerson' do
    render(template: 'templates/ticket/ticket',
           layout: nil,
           locals: {
             user: @privat_user,
             event: @privat_user.event_registrations.first.event_pricegroup.event.root,
             ticket_number: 'Ticket-123'})
    rendered.should_not have_content('privat Person')
    rendered.should have_content('Zossener Str. 55')
    rendered.should have_content('10961 Berlin')
  end
end