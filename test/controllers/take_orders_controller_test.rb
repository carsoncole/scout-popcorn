require 'test_helper'

class TakeOrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @take_order = take_orders(:one)
    @envelope = envelopes(:one)
  end

  test "should not get index without sign_in" do
    get take_orders_url
    assert_redirected_to controller: 'sessions', action: 'new'
  end

  test "should get index" do
    sign_in(scouts(:one))
    get take_orders_url
    assert_response :success
  end

  test "should get new" do
    sign_in(scouts(:one))
    get new_take_order_url
    assert_response :success
  end

  test "should create take order" do
    sign_in(scouts(:one))
    assert_difference('TakeOrder.count') do
      post take_orders_url, params: { take_order: { envelope_id: @envelope.id, customer_name: 'Someone', payment_account_id: accounts(:take_orders_cash).id } }
    end

    assert_redirected_to take_order_url(TakeOrder.last)
  end

  test "should get edit" do
    sign_in(scouts(:one))
    get edit_take_order_url(@take_order)
    assert_response :success
  end

  test "should update take order" do
    sign_in(scouts(:one))
    patch take_order_url(@take_order), params: { take_order: { envelope_id: @envelope.id, customer_name: 'new name' } }
    assert_redirected_to take_order_url(@take_order)
  end

  test "should destroy take order" do
    sign_in(scouts(:one))
    assert_difference('TakeOrder.count', -1) do
      delete take_order_url(@take_order)
    end

    assert_redirected_to take_orders_url
  end

  # admin

  test "should get index as admin" do
    sign_in(scouts(:take_orders_admin))
    get take_orders_url
    assert_response :success
  end

  test "should get new as admin" do
    sign_in(scouts(:take_orders_admin))
    get new_take_order_url
    assert_response :success
  end

  test "should create take order as admin" do
    sign_in(scouts(:take_orders_admin))
    assert_difference('TakeOrder.count') do
      post take_orders_url, params: { take_order: { envelope_id: @envelope.id, customer_name: 'Someone', payment_account_id: accounts(:take_orders_cash).id } }
    end

    assert_redirected_to take_order_url(TakeOrder.last)
  end

  test "should show take order as admin" do
    sign_in(scouts(:take_orders_admin))
    get take_order_url(@take_order)
    assert_response :success
  end

  test "should get edit as admin" do
    sign_in(scouts(:take_orders_admin))
    get edit_take_order_url(@take_order)
    assert_response :success
  end

  test "should update take order as admin" do
    sign_in(scouts(:take_orders_admin))
    patch take_order_url(@take_order), params: { take_order: { envelope_id: @envelope.id, customer_name: 'new name' } }
    assert_redirected_to take_order_url(@take_order)
  end

  test "should destroy take order as admin" do
    sign_in(scouts(:take_orders_admin))
    assert_difference('TakeOrder.count', -1) do
      delete take_order_url(@take_order)
    end

    assert_redirected_to take_orders_url
  end
end
