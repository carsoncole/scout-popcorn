require 'test_helper'

class TakeOrdersControllerTest < ActionDispatch::IntegrationTest
  # setup do
  #   @take_order = orders(:one)
  # end

  test "should get index" do
    sign_in(scouts(:one))
    get take_orders_url
    assert_response :success
  end

  # test "should get new" do
  #   get new_order_url
  #   assert_response :success
  # end

  # test "should create order" do
  #   assert_difference('Order.count') do
  #     post orders_url, params: { order: { scout_id: @take_order.scout_id, status_id: @take_order.status_id } }
  #   end

  #   assert_redirected_to order_url(Order.last)
  # end

  # test "should show order" do
  #   get order_url(@take_order)
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get edit_order_url(@take_order)
  #   assert_response :success
  # end

  # test "should update order" do
  #   patch order_url(@take_order), params: { order: { scout_id: @take_order.scout_id, status_id: @take_order.status_id } }
  #   assert_redirected_to order_url(@take_order)
  # end

  # test "should destroy order" do
  #   assert_difference('Order.count', -1) do
  #     delete order_url(@take_order)
  #   end

  #   assert_redirected_to orders_url
  # end
end
