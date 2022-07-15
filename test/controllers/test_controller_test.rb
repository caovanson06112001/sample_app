require "test_helper"

class TestControllerTest < ActionDispatch::IntegrationTest
  test "should get test1" do
    get test_test1_url
    assert_response :success
  end

  test "should get test2" do
    get test_test2_url
    assert_response :success
  end
end
