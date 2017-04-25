require 'test_helper'

class OnlineSaleTest < ActiveSupport::TestCase
  setup do
    @online_sale = OnlineSale.new(scout: scouts(:one), event: events(:one), amount: 100, customer_name: 'Mike Jackson')
  end
  
  test "should save" do
    assert @online_sale.save
  end

  test "should not save without amount" do
    @online_sale.amount = nil
    assert_not @online_sale.valid?
  end
end