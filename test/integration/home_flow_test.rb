require 'test_helper'

class HomeFlowTest < Capybara::Rails::TestCase
  test 'home index' do
    visit root_path

    assert page.has_content?('Corn Cub')

    fill_in 'email', with: 'two@example.com'
    fill_in 'password', with: 'password'
    click_button 'Log in'

    assert_current_path home_path
    assert page.has_content?('My Sales')
  end
end