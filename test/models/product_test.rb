require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  setup do
    @product = Product.new(name: 'Caramel Popcorn', is_physical_inventory: true, retail_price: 10)
  end

  test "should be invalid without a price" do
    @product.retail_price = nil
    assert_not @product.valid?
  end

  test "should not be bsa-sourced if unit donation" do
    @product.is_pack_donation = true
    @product.is_sourced_from_bsa = true
    assert_not @product.valid?
    assert @product.errors[:is_sourced_from_bsa]
  end

  test "should have $1 price if unit donation" do
    @product.is_pack_donation = true
    @product.is_sourced_from_bsa = false
    assert_not @product.valid?
    assert @product.errors[:retail_price]
  end

  test "should not be destroyable if used" do
    product = products(:one)
    product.destroy
    assert_equal product.errors[:base].first, "Product can not be modified/destroyed since it has been used."
  end

  test "should not allow price changes if used" do
    product = products(:one)
    product.retail_price = 99
    product.save
    assert_equal product.errors[:base].first, "Product can not be modified/destroyed since it has been used."
  end

end