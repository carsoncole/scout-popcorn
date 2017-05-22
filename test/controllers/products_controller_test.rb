require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
    @product_unused = products(:unused)
  end

  test "should not get index without sign_in" do
    get products_url
    assert_redirected_to controller: 'sessions', action: 'new'
  end

  test "should get index" do
    sign_in(scouts(:one))
    get products_url
    assert_response :success
  end

  test "should not show new link" do
    sign_in(scouts(:one))
    get products_url
    assert_select "fa.fa.fa-plus", false
  end

  test "should not show pencil edit link" do
    sign_in(scouts(:one))
    get products_url
    assert_select "i.fa-pencil", false
  end

  test "should not get stocks index" do 
    sign_in(scouts(:one))
    get stocks_path
    assert_response :redirect
    assert_redirected_to home_path
  end

  test "should not get stocks ledger" do 
    sign_in(scouts(:one))
    get stocks_ledger_path
    assert_response :redirect
    assert_redirected_to home_path
  end

  # Admin

  test "should show products as unit admin" do
    sign_in(scouts(:unit_admin))
    get products_url
    assert_response :success
  end

  test "should show new link as unit admin" do
    sign_in(scouts(:unit_admin))
    get products_url
    assert_select "a[href=?]", "/products/new"
  end

  test "should not show new link as take orders admin" do
    sign_in(scouts(:take_orders_admin))
    get products_url
    assert_select "a[href=?]", "/products/new", 0
  end

  test "should show pencil edit link" do
    sign_in(scouts(:unit_admin))
    get products_url
    assert_select "i.fa-pencil"
  end

  test "should get new" do
    sign_in(scouts(:unit_admin))
    get new_product_url
    assert_response :success
  end

  test "should create product" do
    sign_in(scouts(:unit_admin))
    assert_difference('Product.count') do
      post products_url, params: { product: { name: 'A New Product', retail_price: 10 } }
    end

    assert_redirected_to products_path
  end

  test "should show product" do
    sign_in(scouts(:unit_admin))
    get product_url(@product)
    assert_response :success
  end

  test "should get edit" do
    sign_in(scouts(:unit_admin))
    get edit_product_url(@product)
    assert_response :success
  end

  test "should update product" do
    sign_in(scouts(:unit_admin))
    patch product_url(@product_unused), params: { product: { name: @product_unused.name, retail_price: @product_unused.retail_price } }
    assert_redirected_to products_path
  end

  test "should destroy product" do
    sign_in(scouts(:unit_admin))
    assert_difference('Product.count', -1) do
      delete product_url(@product_unused)
    end

    assert_redirected_to products_url
  end

  test "should get ledger as admin" do
    sign_in(scouts(:unit_admin))
    get stocks_ledger_path
    assert_response :success
  end
end
