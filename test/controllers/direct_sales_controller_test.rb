require 'test_helper'

class DirectSalesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @direct_sale = direct_sales(:one)
  end

  test "should get index" do
    get direct_sales_url
    assert_response :success
  end

  test "should get new" do
    get new_direct_sale_url
    assert_response :success
  end

  test "should create direct_sale" do
    assert_difference('DirectSale.count') do
      post direct_sales_url, params: { direct_sale: { amount: @direct_sale.amount, event_id: @direct_sale.event_id, product_id: @direct_sale.product_id, quantity: @direct_sale.quantity, scout_id: @direct_sale.scout_id } }
    end

    assert_redirected_to direct_sale_url(DirectSale.last)
  end

  test "should show direct_sale" do
    get direct_sale_url(@direct_sale)
    assert_response :success
  end

  test "should get edit" do
    get edit_direct_sale_url(@direct_sale)
    assert_response :success
  end

  test "should update direct_sale" do
    patch direct_sale_url(@direct_sale), params: { direct_sale: { amount: @direct_sale.amount, event_id: @direct_sale.event_id, product_id: @direct_sale.product_id, quantity: @direct_sale.quantity, scout_id: @direct_sale.scout_id } }
    assert_redirected_to direct_sale_url(@direct_sale)
  end

  test "should destroy direct_sale" do
    assert_difference('DirectSale.count', -1) do
      delete direct_sale_url(@direct_sale)
    end

    assert_redirected_to direct_sales_url
  end
end
