require "test_helper"

class TermsControllerTest < ActionDispatch::IntegrationTest
  test "should get of" do
    get terms_of_url
    assert_response :success
  end

  test "should get Service" do
    get terms_Service_url
    assert_response :success
  end
end
