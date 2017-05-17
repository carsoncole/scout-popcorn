require 'test_helper'

class TakeOrderTest < ActiveSupport::TestCase

  setup do
    @take_order = take_orders(:one)
  end

  test "should be valid" do
    @take_order.valid?
    puts @take_order.errors.full_messages
    assert @take_order.valid?
  end

  test "should not be valid without payment account" do
    @take_order.payment_account_id = nil
    assert_not @take_order.valid?
  end

  test "should show value of line items" do
  end

  test "should output products and quantities" do
  end

  test "should add to purchase order" do
  end

  test "should be removed from purchase order" do
  end

  test "should send a reciept" do
  end

  test "should be assigned to an envelope" do
  end

  # test "should show correct closed sales" do
  #   site_sale = site_sales(:ace)
  #   site_sale.update(closed_at: Time.now)

  #   assert_equal events(:one).total_site_sale_sales, 520
  # end

  # test "should show closed" do
  #   site_sale = site_sales(:ace)
  #   assert_empty site_sale.event.site_sales.closed.where("site_sales.id = ?", site_sale.id)
  #   site_sale.update_column(:closed_at, Time.now)
  #   assert site_sale.event.site_sales.closed.where("site_sales.id = ?", site_sale.id).any?
  # end

  # test "should show open" do
  #   site_sale = site_sales(:ace)
  #   assert site_sale.event.site_sales.open.where("site_sales.id = ?", site_sale.id).any?
  #   site_sale.update_column(:closed_at, Time.now)
  #   assert_empty site_sale.event.site_sales.open.where("site_sales.id = ?", site_sale.id)
  # end

  # test "payments_balance should balance" do
  #   assert @take_order.payments_balance?
  # end

  # test "should show hours worked" do
  #   assert_equal @take_order.hours_worked(scouts(:one)), 2
  #   assert_equal @take_order.hours_worked, 8
  # end

  # test "should show sales" do
  #   assert_equal @take_order.sales(scouts(:one)), 454
  #   assert_equal @take_order.sales, 250   
  # end

  # test "should debit stock when closed" do
  #   product_id = site_sale_line_items(:one).product_id
  #   original_stock = @take_order.event.stocks.site_sales.where(product_id: product_id).sum(:quantity)
  #   @take_order.update(closed_at: Time.now)
  #   new_stock = @take_order.event.stocks.site_sales.where(product_id: product_id).sum(:quantity)
  #   assert_equal original_stock - 10, new_stock
  # end

  # test "should do ledger transactions when closed" do
  #   event = @take_order.event
  #   original_balance = Account.site_sale(event).balance
  #   @take_order.update(closed_at: Time.now)
  #   new_balance = Account.site_sale(event).balance
  #   assert_equal original_balance + 250, new_balance
  # end

  # test "should credit stock when reopened" do
  #   @take_order.update(closed_at: Time.now)
  #   product_id = site_sale_line_items(:one).product_id
  #   original_stock = @take_order.event.stocks.site_sales.where(product_id: product_id).sum(:quantity)
  #   @take_order.update(closed_at: nil)
  #   new_stock = @take_order.event.stocks.site_sales.where(product_id: product_id).sum(:quantity)
  #   assert_equal original_stock + 10, new_stock
  # end

  # test "should reverse ledgers when reopened" do
  #   event = @take_order.event
  #   @take_order.update(closed_at: Time.now)
  #   original_balance = Account.site_sale(event).balance
  #   @take_order.update(closed_at: nil)
  #   new_balance = Account.site_sale(event).balance
  #   assert_equal original_balance - 250, new_balance
  # end

end