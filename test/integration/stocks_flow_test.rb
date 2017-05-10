require 'test_helper'

class StocksFlowTest < Capybara::Rails::TestCase
  include ActionView::Helpers::NumberHelper
  include ApplicationHelper

  

  test "should transfer in some stock from bsa" do
    unit = units(:three)
    scout = unit.scouts.create(first_name: 'Mike', last_name: 'Jones', is_admin: true, is_unit_admin: true, is_warehouse_admin: true, is_site_sales_admin: true, email: 'email@example.com', password: 'password')
    event = unit.events.create(name: 'Popcorn 3000')
    site_sale = event.site_sales.create(name: 'Radio Shack', date: Date.today)    

    Product.create([
      {name: 'White Cheddar Cheese Corn', event_id: event.id, retail_price: 20 },
      {name: 'Classic Caramel Corn', event_id: event.id, retail_price: 10 },
      {name: 'Popping Corn', event_id: event.id, retail_price: 10 }
      ])

    products = event.products

    capybara_login(scout) 

    # transfer from bsa
    visit stocks_ledger_path

    click_link 'Add a transfer'
    select products[0].name, from: "stock_product_id"
    fill_in "stock_quantity", with: 100
    select 'warehouse', from: "stock_location"
    check 'stock_is_transfer_from_bsa'
    click_button 'Create stock transfer'
    assert page.has_content? 'Stock was successfully transferred'
  
    click_link 'Add a transfer'
    select products[1].name, from: "stock_product_id"
    fill_in "stock_quantity", with: 100
    select 'warehouse', from: "stock_location"
    check 'stock_is_transfer_from_bsa'
    click_button 'Create stock transfer'
    assert page.has_content? 'Stock was successfully transferred'  
    visit stocks_path 

    assert first('td.quantity').has_content? '100'

    # transfer to site sale
    click_link 'Add a transfer'
    select products[0].name, from: "stock_product_id"
    fill_in "stock_quantity", with: 10
    select 'site sales', from: "stock_location"
    check 'stock_is_transfer_from_warehouse'
    click_button 'Create stock transfer'
    assert page.has_content? 'Stock was successfully transferred'  

    click_link 'Add a transfer'
    select products[1].name, from: "stock_product_id"
    fill_in "stock_quantity", with: 20
    select 'site sales', from: "stock_location"
    check 'stock_is_transfer_from_warehouse'
    click_button 'Create stock transfer'
    assert page.has_content? 'Stock was successfully transferred'


    # check values on site sales inventory
    white_wholesale_value = calculate_wholesale_value( products[0], 10)
    classic_wholesale_value = calculate_wholesale_value( products[1], 20)
    total_wholesale_value = white_wholesale_value + classic_wholesale_value

    visit stocks_path(location: 'site sales')
    assert find('td.white-cheddar-cheese-corn.quantity').has_content? '10'
    assert find('td.classic-caramel-corn.quantity').has_content? '20'
    assert find("td.white-cheddar-cheese-corn.wholesale-value").has_content? number_to_currency(white_wholesale_value, precision: 2)
    assert find("td.classic-caramel-corn.wholesale-value").has_content? number_to_currency(classic_wholesale_value, precision: 2)
    assert find('td.total-wholesale-value').has_content? number_to_currency( total_wholesale_value, precision: 2)



    # check values on ALL inventory
    white_wholesale_value = calculate_wholesale_value( products[0], 100)
    classic_wholesale_value = calculate_wholesale_value( products[1], 100)
    total_wholesale_value = white_wholesale_value + classic_wholesale_value

    visit stocks_path
    assert find('td.white-cheddar-cheese-corn.quantity').has_content? '100'
    assert find('td.classic-caramel-corn.quantity').has_content? '100'
    assert find("td.white-cheddar-cheese-corn.wholesale-value").has_content? number_to_currency(white_wholesale_value, precision: 2)
    assert find("td.classic-caramel-corn.wholesale-value").has_content? number_to_currency(classic_wholesale_value, precision: 2)
    assert find('td.total-wholesale-value').has_content? number_to_currency( total_wholesale_value, precision: 2)


    # close a site sale
    site_sale.site_sale_line_items.create(product: products[0], quantity: 10, value: 200)
    site_sale.site_sale_line_items.create(product: products[1], quantity: 5, value: 50)
    site_sale.site_sale_payment_methods.create(account: Account.site_sale(event), amount: 250 )    

    visit site_sales_path
    click_link "Radio Shack"

    click_button "CLOSE"

    # check values on ALL inventory
    white_wholesale_value = calculate_wholesale_value( products[0], 90)
    classic_wholesale_value = calculate_wholesale_value( products[1], 95)
    total_wholesale_value = white_wholesale_value + classic_wholesale_value

    visit stocks_path
    assert find('td.white-cheddar-cheese-corn.quantity').has_content? '90'
    assert find('td.classic-caramel-corn.quantity').has_content? '95'
    assert find("td.white-cheddar-cheese-corn.wholesale-value").has_content? number_to_currency(white_wholesale_value, precision: 2)
    assert find("td.classic-caramel-corn.wholesale-value").has_content? number_to_currency(classic_wholesale_value, precision: 2)
    assert find('td.total-wholesale-value').has_content? number_to_currency( total_wholesale_value, precision: 2)

    # check balance sheet inventory value
    visit balance_sheet_path
    assert find('td.inventory').has_content? number_to_currency( total_wholesale_value, precision: 2)

  end

end