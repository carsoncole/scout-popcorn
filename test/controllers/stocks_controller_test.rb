require 'test_helper'

class StocksControllerTest < ActionDispatch::IntegrationTest

  setup do
    @stock = stocks(:one)
    @stock.event.stocks.each do |stock|
      stock.update_wholesale_value!
    end
  end

  test "should get index" do
    sign_in(scouts(:admin))
    get stocks_url
    assert_response :success
  end

  test "should get stocks/ledger" do
    sign_in(scouts(:admin))
    get stocks_ledger_url
    assert_response :success
  end

  test "should get new" do
    sign_in(scouts(:admin))
    get new_stock_url
    assert_response :success
  end

  test "should get edit" do
    sign_in(scouts(:admin))
    get edit_stock_url(@stock)
    assert_response :success
  end

  test "should update stock" do
    sign_in(scouts(:admin))
    patch stock_url(@stock), params: { stock: { product_id: @stock.product_id, quantity: @stock.quantity, event_id: @stock.event_id } }
    assert_redirected_to stocks_ledger_url
  end

  test "should destroy stock" do
    sign_in(scouts(:admin))
    assert_difference('Stock.count', -1) do
      delete stock_url(@stock)
    end

    assert_redirected_to stocks_ledger_url
  end
end
