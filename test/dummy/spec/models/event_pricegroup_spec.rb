require 'spec_helper'

describe GoldencobraEvents::EventPricegroup do
  before(:each) do
    @new_pricegroup = GoldencobraEvents::EventPricegroup.new
  end
  it "should convert a european delimitted price to a correct price" do
    @new_pricegroup.update_attributes(:price_raw => "1.500,23")
    @new_pricegroup.price.should == 1500.23
  end

  it "should convert an american delimitted price to a correct price" do
    @new_pricegroup.update_attributes(:price_raw => "1,500.23")
    @new_pricegroup.price.should == 1500.23
  end

  it "should convert a price with a comma to a correct price" do
    @new_pricegroup.update_attributes(:price_raw => "1500,23")
    @new_pricegroup.price.should == 1500.23
  end

  it "should convert a price with a point to a correct price" do
    @new_pricegroup.update_attributes(:price_raw => "1500.23")
    @new_pricegroup.price.should == 1500.23
  end
end
