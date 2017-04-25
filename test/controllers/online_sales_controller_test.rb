require 'test_helper'

class OnlineSalesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @online_sale = online_sales(:one)
  end

  test "should get index" do
    sign_in(scouts(:one))
    get online_sales_url
    assert_response :success
  end

  test "should get index and show orders" do
    sign_in(scouts(:one))
    get online_sales_url
    assert_equal css_select("tr").size, 3
  end

  test "should show admin new link" do
    sign_in(scouts(:admin))
    get online_sales_url
    assert_select "a.new-online-sale-link", 1
  end

  test "should get new" do
    sign_in(scouts(:admin))
    get new_online_sale_url
    assert_response :success
  end

  test "should create online_sale" do
    sign_in(scouts(:admin))
    assert_difference('OnlineSale.count') do
      post online_sales_url, params: { online_sale: { amount: @online_sale.amount, customer_name: @online_sale.customer_name, description: @online_sale.description, event_id: @online_sale.event_id, order_date: @online_sale.order_date, scout_id: @online_sale.scout_id } }
    end

    assert_redirected_to online_sales_path
  end

  test "should get edit" do
    sign_in(scouts(:admin))
    get edit_online_sale_url(@online_sale)
    assert_response :success
  end

  test "should update online_sale" do
    sign_in(scouts(:admin))
    patch online_sale_url(@online_sale), params: { online_sale: { amount: 120, customer_name: @online_sale.customer_name, description: @online_sale.description, event_id: @online_sale.event_id, order_date: @online_sale.order_date, scout_id: @online_sale.scout_id } }
    assert_redirected_to online_sales_path
  end

  test "should destroy online_sale" do
    sign_in(scouts(:admin))
    assert_difference('OnlineSale.count', -1) do
      delete online_sale_url(@online_sale)
    end
    assert_redirected_to online_sales_path
  end

  test "should show online sale" do
    sign_in(scouts(:admin))
    post online_sales_url, params: { online_sale: { amount: @online_sale.amount, customer_name: 'Santa Claus', description: "Lots of popcorn", event_id: @online_sale.event_id, order_date: @online_sale.order_date, scout_id: @online_sale.scout_id } }

    sign_in(scouts(:one))
    get online_sales_url
    assert_select "td", "Santa Claus" 
    assert_select "td", "Lots of popcorn"
  end
end
