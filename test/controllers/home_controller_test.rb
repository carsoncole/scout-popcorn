require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest

  test "should get root sign in when not logged in" do
    sign_in(scouts(:one))
    get logout_path
    get root_url
    assert_response :success
  end

  test "should have Home title" do
    sign_in(scouts(:one))
    get home_path
    assert_select 'title', /Home/
  end

  test "should get dashboard when logged in" do
    sign_in(scouts(:one))
    get root_url
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end

  test "should show Scout sales table" do
    sign_in(scouts(:one))
    follow_redirect!
    assert_select ".my-sales", "My Sales"
    assert_select "th.take_orders"
    assert_select "th.site_sales"
    assert_select "th.online_sales"
  end

  test "should show Upcoming Site Sales" do
    sign_in(scouts(:one))
    follow_redirect!
    assert_select ".site-sales", /Site Sales/
    assert_select "td.site_sale_date", 3
    assert_select "td.site_sale_name", "Safeway"
  end

  test "should show top sellers" do
    sign_in(scouts(:one))
    follow_redirect!
    assert_select ".top-sellers", "Top Sellers"
  end

  test "should show resources" do
    sign_in(scouts(:one))
    follow_redirect!
    assert_select ".resources", "More info"
    assert_select "li.resource", 2
  end

  test "should show important dates" do
    sign_in(scouts(:one))
    follow_redirect!
    assert_select "ul.important_dates"
  end

  test "should show online sales total" do
    sign_in(scouts(:one))
    follow_redirect!
    assert_select ".my-sales", "My Sales"
    assert_select "td.online_sales_amount", "$125" 
  end

  test "should show admin online sales total" do
    sign_in(scouts(:admin))
    follow_redirect!
    assert_select ".my-sales", "Sales"
    assert_select "td.online_sales_amount", "$275" 
  end


  test "should show online sale" do
    sign_in(scouts(:admin))
    post online_sales_url, params: { online_sale: { amount: 99, customer_name: 'Santa Claus', description: "Lots of popcorn", event_id: events(:one).id, order_date: '2017-01-01', scout_id: scouts(:one).id} }

    sign_in(scouts(:one))
    follow_redirect!
    assert_select "td.onfline_sales_amount", "$224" 
  end

  test "should show site sales cash for site sales admin" do
    sign_in(scouts(:site_sales_admin))
    follow_redirect!
    assert_select ".site_sales_cash"
  end

  test "should show site sales cash for take orders admin" do
    sign_in(scouts(:take_orders_admin))
    follow_redirect!
    assert_select ".take_orders_cash"
  end

end