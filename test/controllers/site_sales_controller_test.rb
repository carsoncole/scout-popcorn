require 'test_helper'

class SiteSalesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @site_sale = site_sales(:safeway)
  end

  test "should get index" do
    sign_in(scouts(:one))
    get site_sales_url
    assert_response :success
  end

  test "should not show new link" do
    sign_in(scouts(:one))
    get site_sales_url
    assert_select "a.new-site-sale-link", false
  end

  test "should show admin new link" do
    sign_in(scouts(:admin))
    get site_sales_url
    assert_select "a.new-site-sale-link", 1
  end

  test "should get new" do
    sign_in(scouts(:admin))
    get new_site_sale_url
    assert_response :success
  end

  test "should create site_sale" do
    sign_in(scouts(:admin))
    assert_difference('SiteSale.count') do
      post site_sales_url, params: { site_sale: { event_id: @site_sale.event_id, date: @site_sale.date, name: @site_sale.name } }
    end

    assert_redirected_to site_sales_path
  end

  test "should get edit" do
    sign_in(scouts(:admin))
    get edit_site_sale_url(@site_sale)
    assert_response :success
  end

  test "should update site_sale" do
    sign_in(scouts(:admin))
    patch site_sale_url(@site_sale), params: { site_sale: { event_id: @site_sale.event_id, name: 'Dominos' } }
    assert_redirected_to site_sale_url(@site_sale)
  end

  test "should destroy site_sale" do
    sign_in(scouts(:admin))
    assert_difference('SiteSale.count', -1) do
      delete site_sale_url(@site_sale)
    end

    assert_redirected_to site_sales_url
  end
end
