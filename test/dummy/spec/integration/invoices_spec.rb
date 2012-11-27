require 'spec_helper'

describe "Generating documents" do
  it 'should generate a valid invoice' do
    GoldencobraEvents::Event.create(title: 'Test')
  end
end