require 'test_helper'

class LedgersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ledger = ledgers(:one)
  end

  test "should get index" do
    sign_in(scouts(:financial_admin))
    get ledgers_url
    assert_response :success
  end

  test "should get bank deposit" do
    sign_in(scouts(:financial_admin))
    get bank_deposit_url
    assert_response :success
  end

  test "should get transaction fund site sales" do
    sign_in(scouts(:financial_admin))
    get fund_site_sales_url
    assert_response :success
  end

  test "should get transaction exp reimbursement 1" do
    sign_in(scouts(:financial_admin))
    get expense_reimbursement_1_url
    assert_response :success
  end

  test "should get transaction exp reimbursement 2" do
    sign_in(scouts(:financial_admin))
    get expense_reimbursement_2_url
    assert_response :success
  end

  test "should get transaction exp reimbursement 2" do
    sign_in(scouts(:financial_admin))
    get expense_reimbursement_2_url
    assert_response :success
  end

  test "should get balance sheet" do
    sign_in(scouts(:financial_admin))
    get balance_sheet_url
    assert_response :success
  end

  test "should get income statement" do
    sign_in(scouts(:financial_admin))
    get income_statement_url
    assert_response :success
  end

  test "should get new" do
    sign_in(scouts(:financial_admin))
    get new_ledger_url
    assert_response :success
  end

  test "should create ledger" do
    sign_in(scouts(:financial_admin))
    assert_difference('Ledger.count') do
      post ledgers_url, params: { ledger: { account_id: @ledger.account_id, amount: @ledger.amount, date: @ledger.date, description: @ledger.description } }
    end

    assert_redirected_to ledgers_url
  end

  test "should show ledger" do
    sign_in(scouts(:financial_admin))
    get ledger_url(@ledger)
    assert_response :success
  end

  test "should get edit" do
    sign_in(scouts(:financial_admin))
    get edit_ledger_url(@ledger)
    assert_response :success
  end

  test "should update ledger" do
    sign_in(scouts(:financial_admin))
    patch ledger_url(@ledger), params: { ledger: { account_id: @ledger.account_id, amount: @ledger.amount, date: @ledger.date, description: @ledger.description } }
    assert_redirected_to ledger_url(@ledger)
  end

  test "should destroy ledger" do
    sign_in(scouts(:financial_admin))
    assert_difference('Ledger.count', -1) do
      delete ledger_url(@ledger)
    end

    assert_redirected_to ledgers_url
  end
end
