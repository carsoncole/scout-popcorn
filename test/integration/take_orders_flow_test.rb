require 'test_helper'

class TakeOrdersFlowTest < Capybara::Rails::TestCase

  test "should successfully enter a take order" do
    capybara_login(scouts(:one)) 

    visit take_orders_path
    click_link 'Add a Take Order'
    fill_in "Customer name", with: 'John Doe'
    fill_in "take_order_customer_address", with: '123 Main Street'
    select 'Cash/Check', from: "take_order_payment_account_id"
    click_button 'Save'
    
    assert page.has_content? 'Customer details were entered'
    click_link 'Add a product sold'
    select products(:one).name, from: "take_order_line_item_product_id"
    select '2', from: 'Quantity'
    click_button 'Save'

    assert page.has_content? 'Product was added to the Take Order'
    click_link 'Add a product sold'
    select products(:two).name, from: "take_order_line_item_product_id"
    select '1', from: 'Quantity'
    click_button 'Save'

    assert page.has_content? '$30'

    click_link 'Back to Take Orders'
  end

end