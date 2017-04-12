require 'test_helper'

class EventTest < ActiveSupport::TestCase
  def setup
    @event = Event.new(name: 'Some Event 20XX', unit_commission_percentage: 30, online_commission_percentage: 30, number_of_top_sellers: 10)
  end

  test "valid event is created" do
    assert @event.valid?
  end

  test "event is not valid without name" do
    @event.name = nil
    assert @event.invalid?
  end

  test "event is not valid with out-of-range commissions" do
    @event.unit_commission_percentage, @event.online_commission_percentage = 200
    assert @event.invalid?
    assert_equal [:unit_commission_percentage, :online_commission_percentage].sort, @event.errors.keys.sort
  end
end