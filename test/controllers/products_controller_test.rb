require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
    @product_unused = products(:unused)
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

  # Admin

  test "should show products" do
    sign_in(scouts(:admin))
    get products_url
    assert_response :success
  end

  test "should show new link" do
    sign_in(scouts(:admin))
    get products_url
    assert_select "fa.fa.fa-plus"
  end

  test "should show pencil edit link" do
    sign_in(scouts(:admin))
    get products_url
    assert_select "i.fa-pencil"
  end

  test "should get new" do
    sign_in(scouts(:admin))
    get new_product_url
    assert_response :success
  end

  test "should create product" do
    sign_in(scouts(:admin))
    assert_difference('Product.count') do
      post products_url, params: { product: { name: 'A New Product', retail_price: 10 } }
    end

    assert_redirected_to products_path
  end

  test "should show product" do
    sign_in(scouts(:admin))
    get product_url(@product)
    assert_response :success
  end

  test "should get edit" do
    sign_in(scouts(:admin))
    get edit_product_url(@product)
    assert_response :success
  end

  test "should update product" do
    sign_in(scouts(:admin))
    patch product_url(@product_unused), params: { product: { name: @product_unused.name, retail_price: @product_unused.retail_price } }
    assert_redirected_to products_path
  end

  test "should destroy product" do
    sign_in(scouts(:admin))
    assert_difference('Product.count', -1) do
      delete product_url(@product_unused)
    end

    assert_redirected_to products_url
  end
end
