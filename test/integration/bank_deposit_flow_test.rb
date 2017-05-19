require 'test_helper'

class BankDepositFlowTest < Capybara::Rails::TestCase

  test "should successfully enter an online sale" do
    capybara_login(scouts(:site_sales_admin))
    visit ledger_transactions_path
    click_button 'Make a Bank deposit'
    select 'Site Sales cash', from: "ledger_from_account_id"
    select 'Unit bank account', from: "ledger_account_id"
    fill_in 'ledger_amount', with: '150'
    click_button 'Record Deposit'

    assert page.has_content? 'Bank deposit to Unit bank account'
    assert page.has_content? '$150.00'
    assert page.has_content? '-$150.00'

    visit balance_sheet_path
    assert find('td.unit-bank-account').has_content? '$150.00'
  end

end