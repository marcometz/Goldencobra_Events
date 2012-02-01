require 'test_helper'

module GoldencobraEvents
  class EventsControllerTest < ActionController::TestCase
    test "should get show" do
      get :show
      assert_response :success
    end
  
  end
end
