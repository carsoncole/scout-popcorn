require 'test_helper'

class StatementControllerTest < ActionDispatch::IntegrationTest

  test "should get balance sheet" do
    sign_in(scouts(:unit_admin))
    get balance_sheet_url
    assert_response :success
  end

  test "should get income statement" do
    sign_in(scouts(:unit_admin))
    get income_statement_url
    assert_response :success
  end

  test "should not get balance sheet without admin sign_in" do
    get balance_sheet_url
    assert_redirected_to controller: 'sessions', action: 'new'
  end

  test "should not get income statement without admin sign_in" do
    get income_statement_url
    assert_redirected_to controller: 'sessions', action: 'new'
  end

  test "should not get balance sheet" do
    sign_in(scouts(:one))
    get balance_sheet_url
    assert_redirected_to controller: 'home', action: 'index'
  end

  test "should not get income statement" do
    sign_in(scouts(:one))
    get income_statement_url
    assert_redirected_to controller: 'home', action: 'index'
  end

end
