require 'test_helper'

class LedgerTest < ActiveSupport::TestCase
  
  test "should destroy related double-entries"  do
    de = DoubleEntry.create
    assert_difference 'Ledger.count', 2 do
      @ledger_1 = Ledger.create(account_id: accounts(:site_sale_cash).id, amount: 100, double_entry_id: de.id )
      @ledger_2 = Ledger.create(account_id: accounts(:due_to_bsa).id, amount: 100, double_entry_id: de.id )
    end

    assert_difference 'Ledger.count', -2 do
      @ledger_1.destroy
    end
  end

end
