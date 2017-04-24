require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  setup do
    @product = Product.new(name: 'Caramel Popcorn', is_physical_inventory: true, retail_price: 10)
  end

  test "should be invalid without a price" do
    @product.retail_price = nil
    assert_not @product.valid?
  end
end