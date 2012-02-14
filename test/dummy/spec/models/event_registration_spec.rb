require 'spec_helper'

describe GoldencobraEvents::EventRegistration do
  before(:each) do
    @event = GoldencobraEvents::Event.create!
    @event_pricegroup = GoldencobraEvents::EventPricegroup.create!
    @event_pricegroup.event = @event
    @new_registration = GoldencobraEvents::EventRegistration.new
    @new_registration.event_pricegroup = @event_pricegroup
  end
  describe "Registration" do
    it "should reject a registration if the date is invalid" do
      @event.update_attributes(:start_date=>(Date.today - 1.week), :end_date => (Date.today - 1.day))
      @new_registration.is_registerable? should_not == true
    end
  end
end
