require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest

  setup do
    post '/sessions', params: { email: 'mary@example.com', password: 'password'}
  end

  test "should get root sign in when not logged in" do
    get logout_path
    get root_url
    assert_response :success
  end

  test "should get dashboard when logged in" do
    get root_url
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end

  test "should show Scout sales table" do
    follow_redirect!
    assert_select "h1", "My Sales"
    assert_select "th.take_orders"
    assert_select "th.site_sales"
    assert_select "th.online_sales"
  end

  test "should show Upcoming Site Sales" do
    follow_redirect!
    assert_select "h5", "Upcoming Site Sales"
    assert_select "li.site_sale", 3
    assert_select "li.site_sale", "Safeway - #{(Date.today + 10.days).strftime('%b %-d')}"
  end

  test "should show top sellers" do
    follow_redirect!
    assert_select "h5", "Top Sellers"
  end

  test "should show resources" do
    follow_redirect!
    assert_select "h5", "More info"
    assert_select "li.resource", 2
  end

  test "should show important dates" do
    follow_redirect!
    assert_select "ul.important_dates"
  end

  test "should show online sales total" do
    sign_in(scouts(:one))
    follow_redirect!
    assert_select "h1", "My Sales"
    assert_select "td.online_sales_amount", "$125" 
  end

  test "should show admin online sales total" do
    sign_in(scouts(:admin))
    follow_redirect!
    assert_select "h1", "Sales"
    assert_select "td.online_sales_amount", "$275" 
  end


  test "should show online sale" do
    sign_in(scouts(:admin))
    post online_sales_url, params: { online_sale: { amount: 99, customer_name: 'Santa Claus', description: "Lots of popcorn", event_id: events(:one).id, order_date: '2017-01-01', scout_id: scouts(:one).id} }

    sign_in(scouts(:one))
    follow_redirect!
    assert_select "td.online_sales_amount", "$224" 
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