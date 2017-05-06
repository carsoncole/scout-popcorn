require 'test_helper'

class SiteSaleTest < ActiveSupport::TestCase

  setup do
    @site_sale = site_sales(:safeway)
  end

  test "should be valid" do
    assert @site_sale.valid?
  end

  test "should not be valid without name" do
    @site_sale.name = nil
    assert_not @site_sale.valid?
  end

  test "should show correct closed sales" do
    assert_equal events(:one).total_site_sales ,270
  end


  test "should debit stock when closed" do
  end

  test "should do ledger transactions when closed" do
  end

  test "should credit stock when reopened" do
  end

  test "should reverse ledgers when reopened" do
  end

end