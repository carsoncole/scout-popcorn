require 'test_helper'

class PrizeCartsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @prize_cart = scouts(:one).prize_cart(events(:one))
  end

  test "should get prize cart" do
    sign_in(scouts(:one))
    get prize_cart_url(@prize_cart)
    assert_response :success
  end

  test "should get prize carts index" do
    sign_in(scouts(:prizes_admin))
    get prize_carts_url
    assert_response :success
  end

  test "should get approved prizes" do
    sign_in(scouts(:prizes_admin))
    get approved_prizes_url
    assert_response :success
  end

  test "should order prize cart" do
    sign_in(scouts(:one))
    post order_prizes_url(@prize_cart.id)
    assert_response :redirect
    assert_redirected_to @prize_cart
  end

  test "should un-order prize cart" do
    sign_in(scouts(:one))
    post unorder_prize_cart_url(@prize_cart.id)
    assert_response :redirect
    assert_redirected_to prize_cart_url(@prize_cart)
  end

  test "should order prize" do
    sign_in(scouts(:one))
    post prize_cart_order_url(prize_id: prizes(:one).id)
    assert_response :redirect
    assert_redirected_to prizes_url
  end

  test "should remove prize" do
    sign_in(scouts(:one))
    post prize_removal_url(cart_prizes(:one).id)
    assert_response :redirect
    assert_redirected_to @prize_cart
  end
end