require 'spec_helper'

describe GoldencobraEvents::Artist do
  before(:each) do
    @attr = { :title => "Bodo Wartke", :description => "Ein besonderer Komiker mit Humor" }
    @artist = GoldencobraEvents::Artist.create!(@attr)
  end

  it "should not create a new artist without a title" do
    artist = GoldencobraEvents::Artist.new(@attr.merge(:title => ""))
    artist.should_not be_valid
  end

  it "should display the complete artist name when using the method" do
    @sponsor = GoldencobraEvents::Sponsor.create(:title => "Naturstrom GmbH")
    @artist.sponsors << @sponsor
    @artist.complete_artist_name.should == "Bodo Wartke, Ein besonderer Komike..., Naturstrom GmbH"
  end
end
