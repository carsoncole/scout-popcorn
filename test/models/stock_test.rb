require 'test_helper'

class StockTest < ActiveSupport::TestCase

  setup do
    @stock = Stock.new(event: events(:one), product: products(:one), quantity: 1000, location: 'warehouse', is_transfer_from_bsa: true, date: Date.today)
  end

  test "not valid without product" do
    @stock.product_id = nil
    assert @stock.invalid?
    assert_equal @stock.errors[:product_id].first, "can't be blank"
  end

  test "not valid without location" do
    @stock.location = nil
    assert @stock.invalid?
    assert_equal @stock.errors[:location].last, "is not included in the list"
  end

  test "#wholesale_value balances" do
    assert_equal Stock.wholesale_value(events(:one)), 35700
  end

end