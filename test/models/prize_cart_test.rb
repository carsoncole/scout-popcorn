require 'test_helper'

class PrizeCartTest < ActiveSupport::TestCase

  setup do
    @prize_cart = PrizeCart.new(event_id: events(:one).id, scout_id: scouts(:one).id)
    @prize_cart_one = prize_carts(:one)
  end

  test "should be valid" do
    assert @prize_cart.valid?
  end

  test "should show sales credits available" do
    
    assert_equal 325, @prize_cart_one.sales_credits_available('Unit')
    @prize_cart_one.cart_prizes.delete_all
    assert_equal 1125, @prize_cart_one.sales_credits_available('Unit')
  end

  test "should show unit sales credits used" do
    assert_equal @prize_cart_one.sales_credits_used('Unit'), 800
  end

  test "should show if cart is ordered" do
    assert_difference "PrizeCart.ordered.size", 1 do
      @prize_cart.update(is_ordered_at: Time.now)
    end
  end

  test "should show if cart is approved" do
    assert_difference "PrizeCart.approved.size", 1 do
      @prize_cart.update(is_approved_at: Time.now)
    end
  end

  test "should process automatic prizes" do
    @prize_cart_one.cart_prizes.delete_all
    assert_difference "@prize_cart_one.cart_prizes.count", 3 do
      @prize_cart_one.process_automatic_prizes!
    end
  end

  test "should expense and reverse prizes" do
    prize_cart = prize_carts(:one)
    expense_account = prize_cart.event.accounts.where(name: 'Unit prizes').first

    assert_equal expense_account.ledgers.sum(:amount), 0
    
    prize_cart.update(is_approved_at: Time.now)

    amount = expense_account.ledgers.sum(:amount)
    assert_equal amount, 150
  
    prize_cart.update(is_approved_at: nil)

    amount = expense_account.ledgers.sum(:amount)
    assert_equal amount, 0
  end
end