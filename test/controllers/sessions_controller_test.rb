require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest

  test "should get index" do
     get '/scouts/sign_in'
     assert_response :success
  end

  test "sign_up link shows if unit available" do
    get '/scouts/sign_in'
    assert_select 'a.sign_up_link', 'Sign up'
  end
    
  test "sign_up link no shows when no units" do
    Unit.destroy_all
    get '/scouts/sign_in'
    assert_select 'a.sign_up_link', false
  end

  test "sign-up-your-unit link shows" do
    Rails.configuration.allow_for_multiple_units = true
    get '/scouts/sign_in'
    assert_select 'a.sign-up-your-unit', 'Sign Up Your Unit'
  end

  test "sign-up-your-unit link should not show" do
    Rails.configuration.allow_for_multiple_units = false
    get '/scouts/sign_in'
    assert_select 'a.sign-up-your-unit', false
    Rails.configuration.allow_for_multiple_units = true
  end

end
