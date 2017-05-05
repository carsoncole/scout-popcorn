require 'test_helper'

class SignUpFlowTest < Capybara::Rails::TestCase
  test 'sign up' do
    visit root_path
    click_link 'Sign Up'
    assert_current_path signup_path
    select "Pack 100", :from => "scout_unit_id"
    fill_in 'scout_email', with: 'trial@example.com'
    fill_in 'scout_first_name', with: 'Bill'
    fill_in 'scout_last_name', with: 'Jones'
    fill_in 'scout_password', with: 'password'
    fill_in 'scout_password_confirmation', with: 'password'
    click_button 'Sign up'

    assert_current_path root_path
    assert page.has_content?('Your account was successfully created. Please login to continue')
  end
end