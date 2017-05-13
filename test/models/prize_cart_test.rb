require 'test_helper'

class PrizeCartTest < ActiveSupport::TestCase

  setup do
    @prize_cart = PrizeCart.new(event_id: events(:one).id, scout_id: scouts(:one).id)
  end

  test "should be valid" do
    assert @prize_cart.valid?
  end

  test "should show sales credits available" do
    assert false
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
    assert false
  end

  test "should expense prizes" do
    assert false
  end

  test "should reverse prizes" do
    assert false
  end

  test "should show approved prizes" do
    assert false
  end

end