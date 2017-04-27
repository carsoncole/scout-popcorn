require 'test_helper'

class SiteSaleTest < ActiveSupport::TestCase

  setup do
    @site_sale = site_sales(:walmart)
  end

  #TODO Test code on changing status to 'closed' and 'reopen'

  test "should debit stock when closed" do
  end

  test "should do ledger transactions when closed" do
  end

  test "should credit stock when reopened" do
  end

  test "should reverse ledgers when reopened" do
  end

end