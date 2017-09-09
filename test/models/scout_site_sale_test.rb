require 'test_helper'

class ScoutSiteSaleTest < ActiveSupport::TestCase
  test "should not save without site sale" do
    scout_site_sale = ScoutSiteSale.new(scout_id: scouts(:one).id)
    assert_not scout_site_sale.save
    assert scout_site_sales.errors[:site_sale_id]
  end
end
