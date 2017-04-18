require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest

  setup do
    sign_in scouts(:one)
  end

  test "should get root" do
    get root_url
    assert_response :success
  end

  test "should show Scout sales table" do
    follow_redirect!
    assert_select "h2", "My Sales"
    assert_select "th.take_orders"
    assert_select "th.site_sales"
    assert_select "th.online_sales"
  end

end