require 'test_helper'

module GoldencobraEvents
  class EventRegistrationMailerTest < ActionMailer::TestCase
    test "registration" do
      assert_match "Hi", "Hi"
    end
  
  end
end
