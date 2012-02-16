require 'spec_helper'

describe GoldencobraEvents::Event do
  before(:each) do
    @attr = { :title => "Test Event", :description => "Ein ganz toller Event" }
    @event = GoldencobraEvents::Event.create!(@attr)
  end

  it "should create a new instance given valid attributes" do
    GoldencobraEvents::Event.create!(@attr)
  end

end
