require 'test_helper'

class TakeOrdersOrderControllerTest < ActionDispatch::IntegrationTest

  test "should not get index without sign_in" do
    get take_orders_order_url
    assert_redirected_to controller: 'sessions', action: 'new'
  end

  test "should not get index" do
    sign_in(scouts(:one))
    get take_orders_order_url
    assert_response :redirect
    assert_redirected_to home_url
  end

  test "should get index as admin" do
    sign_in(scouts(:unit_admin))
    get take_orders_order_url
    assert_response :success
  end

end