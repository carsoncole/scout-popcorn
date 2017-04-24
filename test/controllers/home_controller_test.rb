require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest

  setup do
    post '/sessions', params: { email: 'mary@example.com', password: 'password'}
  end

  test "should get root" do
    get root_url
    assert_response :success
  end

  test "should show Scout sales table" do
    follow_redirect!
    assert_select "h3", "My Sales"
    assert_select "th.take_orders"
    assert_select "th.site_sales"
    assert_select "th.online_sales"
  end

  test "should show top sellers" do
    follow_redirect!
    assert_select "h3", "Top Sellers"
  end

  test "should show resources" do
    follow_redirect!
    assert_select "h5", "Additional info"
    assert_select "li.resource", 2
  end

  test "should show important dates" do
    follow_redirect!
    assert_select "ul.important_dates"
  end

end