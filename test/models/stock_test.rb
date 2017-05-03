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

  # test "#wholesale_value balances" do
  #   assert_equal Stock.wholesale_value(events(:one)).to_f, 35700.00
  # end

  test "#create_due_to_bsa should add to ledger" do
    @stock.save
    assert_not_nil @stock.ledger_id
    assert_equal @stock.wholesale_value, @stock.ledger.amount
    assert_equal @stock.id, @stock.ledger.stock_id
  end

  # test "should show correct inventory balance" do
  #   setup_event

  #   assert_equal @event.stocks.where(product_id: @product.id).sum(:quantity), 100
  # end

  # def setup_event
  #   @event = units(:two).events.create(name: 'Popcorn Event')
  #   @product = @event.products.create(name: 'Cheese Popcorn', retail_price: 10)
  #   assert @product.valid?
  #   @stock = @event.stocks.create(product_id: @product.id, location: 'warehouse', is_transfer_from_bsa: true, date: Date.today, quantity: 100)
  # end

end