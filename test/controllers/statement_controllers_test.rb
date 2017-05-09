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

end
