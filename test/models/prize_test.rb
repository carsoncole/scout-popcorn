require 'test_helper'

class PrizeTest < ActiveSupport::TestCase

  setup do
    @prize = Prize.new(name: 'Prize', sales_amount: 100, source: 'Unit', event_id: events(:one).id)
  end

  test "should be valid" do
    assert @prize.valid?
  end

  test "should be invalid without source" do
    @prize.source = nil
    assert_not @prize.valid?
  end

  test "should not be destroyable if used" do
    prize = prizes(:one)
    prize.destroy
    assert_not prize.destroyed?
  end

  test "should not have multiple prizes with same name" do
    @prize.save
    second_prize = Prize.new(name: 'Prize', sales_amount: 100, source: 'Unit', event_id: events(:one).id)
    second_prize.valid?
    assert second_prize.errors[:name].include? 'has already been taken'
  end

end