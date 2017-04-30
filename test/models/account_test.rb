require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  setup do 
    @account = Account.new(name: 'Asset', event: events(:one), account_type: 'Asset')
  end

  test "should be invalid without account_type" do
    @account.account_type = nil
    assert_not @account.valid?
    assert @account.errors[:account_type]
  end

  test "should be invalid without matching account_type" do
    @account.account_type = 'Something'
    assert_not @account.valid?
    assert_equal @account.errors[:account_type].first, "is not included in the list"
  end

  test "should have set account types" do
    array = ['Asset', 'Liability', 'Equity', 'Income', 'Expense']
    assert_equal Account::ACCOUNT_TYPES & array, array 
  end

  test "should be invalid as name not unique" do
    @account.save
    second_account = Account.new(name: 'Asset', event: events(:one), account_type: 'Asset')
    assert_not second_account.valid?
    assert_equal second_account.errors[:name].first, "has already been taken"
  end

end