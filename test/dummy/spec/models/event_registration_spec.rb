require 'spec_helper'

describe GoldencobraEvents::EventRegistration do
  before(:each) do
    @event = GoldencobraEvents::Event.create!(:start_date=>(Date.today - 1.week), 
                                              :end_date => (Date.today + 1.day),
                                              :title => "Mein Event",
                                              :max_number_of_participators => 10)
    pricegroup = GoldencobraEvents::Pricegroup.create(:title => "Studenten")

    @event_pricegroup = GoldencobraEvents::EventPricegroup.create(:max_number_of_participators => 10)
    @event_pricegroup.event_id = @event.id
    @event_pricegroup.pricegroup_id = pricegroup.id
    @event_pricegroup.save

    @new_registration = GoldencobraEvents::EventRegistration.new
    @new_registration.event_pricegroup = @event_pricegroup
    @user = User.create!(:email=>"test@test.de",
                         :password=>"secure12",
                         :password_confirmation=>"secure12")
    @new_registration.user = @user
    @new_registration.save
    @user2 = User.create!(:email=>"second_tester@test.de",
                         :password=>"secure123",
                         :password_confirmation=>"secure123")
  end

  describe "Registration" do
    it "should reject a registration if the date is invalid" do
      @event.update_attributes(:end_date => (Date.today - 1.day))
      @new_registration.is_registerable?.should == {:date_error => "Registration date is not valid"}
    end

    it "should accept a registration if the date is valid" do
      @new_registration.is_registerable?.should == true
    end

    describe "with a second registration" do
      before(:each) do
        @second_reg = GoldencobraEvents::EventRegistration.new
        @second_reg.event_pricegroup = @event_pricegroup
        @second_reg.save
      end

      describe "from a different user" do
        before(:each) do
          @second_reg.update_attributes(:user => @user2)
        end
      
        it "should reject a registration if the maximum number of participants (event) is reached" do
          @new_registration.is_registerable?.should == true
          @event.update_attributes(:max_number_of_participators => 1)
          @second_reg.is_registerable?.should == {:num_of_ev_part_reached => "Maximum number of participants reached for event '#{@event.title}'"}
        end
    
        it "should reject a registration if the pricegroup's maximum number of participants is reached" do
          @new_registration.is_registerable?.should == true
          @event_pricegroup.update_attributes(:max_number_of_participators => 1)
          @second_reg.is_registerable?.should == {:num_of_pricegroup_part_reached => "Maximum number of participants reached for pricegroup '#{@event_pricegroup.pricegroup.title}'"}
        end
      end

      describe "that is exclusive" do
        before(:each) do
          @parent_event = GoldencobraEvents::Event.create(:type_of_event => "No registration needed", :exclusive => true)
          @second_event = GoldencobraEvents::Event.create!(:exclusive => true, :ancestry => "#{@parent_event.id}")
          pricegroup = GoldencobraEvents::Pricegroup.create(:title => "Studenten")
          @second_event_event_pricegroup = GoldencobraEvents::EventPricegroup.create
          @second_event_event_pricegroup.pricegroup_id = pricegroup.id
          @second_event_event_pricegroup.event_id = @second_event.id
          @second_reg.update_attributes(:user => @user, :event_pricegroup => @second_event_event_pricegroup)
          @event.update_attributes(:ancestry => "#{@parent_event.id}")
        end
        it "should reject a registration if its parent is exclusive" do
          @new_registration.is_registerable?.should == {:exclusivity_error => [@second_event.id]}
        end

        it "should accept a registration if parent is not exclusive" do
          @parent_event.update_attributes(:exclusive => false)
          @new_registration.is_registerable?.should == true
        end
      end
    end

    describe "with a parent event" do
      before(:each) do
        @parent_event = GoldencobraEvents::Event.create(:type_of_event => "No registration needed")
        @event.update_attributes(:ancestry => "#{@parent_event.id}")
      end
      it "should approve the registration if parent doesn't need registering" do
        @new_registration.is_registerable?.should == true
      end

      it "should reject the registration if parent needs registering and it's not registered yet" do
        @parent_event.update_attributes(:type_of_event => "Registration needed")
        @new_registration.is_registerable?.should == {:parent_error => [@parent_event.id] }
      end

      it "should reject the registration if there are multiple parents yet to register" do
        @grandfather_event = GoldencobraEvents::Event.create(:type_of_event => "Registration needed")
        @parent_event.update_attributes(:ancestry => "#{@grandfather_event.id}", :type_of_event => "Registration needed")
        @event.update_attributes(:ancestry => "#{@grandfather_event.id}/#{@parent_event.id}")
        @new_registration.is_registerable?.should == {:parent_error => [@grandfather_event.id, @parent_event.id]}
      end
    end
  end
end
