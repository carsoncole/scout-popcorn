require 'test_helper'

class DueFromCustomersControllerTest < ActionDispatch::IntegrationTest

  
  test 'should not get index without sign_in' do
    get due_from_customers_url
    assert_redirected_to controller: 'sessions', action: 'new'
  end

  test 'should not get index' do
    sign_in(scouts(:one))
    get due_from_customers_url
    assert_response :redirect
    assert_redirected_to home_path
  end

  test 'should get index for admin' do
    sign_in(scouts(:financial_admin))
    get due_from_customers_url
    assert_response :success
  end
end