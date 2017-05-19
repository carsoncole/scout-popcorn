require 'test_helper'

class OnlineSalesFlowTest < Capybara::Rails::TestCase

  test "should successfully enter an online sale" do
    capybara_login(scouts(:online_sales_admin))
    visit online_sales_path
    click_link 'Add an online sale' 
    select scouts(:one).name, from: "online_sale_scout_id"
    fill_in 'Customer name', with: 'John Doe'
    fill_in 'Amount', with: '150'
    click_button 'Save'
    assert page.has_content? 'Online sale was successfully created.'
    assert page.has_content? '$150.00'
    assert page.has_content? scouts(:one).name
  end

end