require "test_helper"

class ScanControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get scan_index_url
    assert_response :success
  end
end
