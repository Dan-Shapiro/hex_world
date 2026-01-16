require "test_helper"

class WorldControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get world_show_url
    assert_response :success
  end
end
