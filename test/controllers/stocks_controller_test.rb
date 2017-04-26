require 'test_helper'

class StocksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @stock = stocks(:one)
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

  test "should create stock" do
    sign_in(scouts(:admin))
    assert_difference('Stock.count') do
      post stocks_url, params: { stock: { product_id: @stock.product_id, quantity: @stock.quantity, event_id: @stock.event_id, location: @stock.location, date: Date.today } }
    end

    assert_redirected_to stocks_ledger_path
  end

  test "should create stock movement with warehouse" do
    sign_in(scouts(:admin))
    assert_difference('Stock.count', 2) do
      post stocks_url, params: { stock: { product_id: @stock.product_id, quantity: @stock.quantity, event_id: @stock.event_id, location: 'site sales', date: Date.today, movement_with_warehouse: 1 } }
    end
    assert_redirected_to stocks_ledger_path

    two_ledger_entries = Stock.all[-2..-1]

    # quantities should cancel each other
    assert_equal two_ledger_entries.inject(0) {|sum, e| sum + e.quantity}, 0
  end

  test "should show balance" do
    sign_in(scouts(:admin))
    get stocks_path, params: { location: 'warehouse' }
    assert_select "td.quantity", "1050"
  end

  test "wholesale value should balance" do
    sign_in(scouts(:admin))
    get stocks_path
    assert_select "td.wholesale-value", "$34,125.00"
  end

  test "inventory wholesale_value = financials inventory value" do
    sign_in(scouts(:admin))
    get stocks_path
    wholesale_value = (css_select("td.wholesale-value")).first
    get balance_sheet_path
    balance_sheet_value = (css_select("td.popcorn-inventory")).first
    assert_equal wholesale_value.content, balance_sheet_value.content
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
