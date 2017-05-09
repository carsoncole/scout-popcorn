require 'test_helper'

class StockTest < ActiveSupport::TestCase
  include ApplicationHelper

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

  test "should debit warehouse" do
    original_balance = @stock.balance('warehouse')
    @stock.is_transfer_from_bsa = false
    @stock.is_transfer_from_warehouse = true
    @stock.location = 'site sales'
    @stock.save
    new_balance = @stock.balance('warehouse')
    assert_equal original_balance, new_balance + 1000
  end

  test "should create due-to-bsa" do
    original_balance = Account.due_to_bsa(@stock.event).balance
    @stock.save
    bsa_value = calculate_wholesale_value(@stock.product, @stock.quantity)
    new_balance = Account.due_to_bsa(@stock.event).balance

    assert_equal original_balance + bsa_value, new_balance      
  end

  test "should update wholesale value" do
    product = @stock.product
    @stock.save    
    wholesale = @stock.wholesale_value
    assert_equal wholesale, calculate_wholesale_value(product, @stock.quantity)
    @stock.quantity = 500
    @stock.save
    wholesale = @stock.wholesale_value
    assert_equal wholesale, calculate_wholesale_value(product, @stock.quantity)
  end

end