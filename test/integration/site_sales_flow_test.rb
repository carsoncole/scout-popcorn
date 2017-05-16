require 'test_helper'

class SiteSalesFlowTest < Capybara::Rails::TestCase
  include ActionView::Helpers::NumberHelper

  test "should successfully enter a site sales" do
    capybara_login(scouts(:admin)) 

    site_sale = site_sales(:walmart)
    event = events(:one)
    products = event.products
    scouts = units(:one).scouts.not_admin

    event.stocks.each do |stock|
        stock.update_wholesale_value!
    end     

    # enter product sold at site sale
    visit site_sale_path(site_sale)
    click_link 'Add product sold'
    select products(:five).name, from: "site_sale_line_item_product_id"
    fill_in "site_sale_line_item_quantity", with: 10
    click_button 'Save'
    assert page.has_content? 'There is insufficient inventory'

    # transfer stock to site sales
    visit stocks_ledger_path
    click_link 'Add a transfer'
    select products(:one).name, from: "stock_product_id"
    fill_in "stock_quantity", with: 20
    select 'site sales', from: "stock_location"
    check 'stock_is_transfer_from_warehouse'
    click_button 'Create stock transfer'
    assert page.has_content? 'Stock was successfully transferred'

    #visit balance sheet for original inventory
    visit balance_sheet_path
    assert page.has_content? "Balance Sheet"
    original_inventory = 33800
    assert find('td.inventory').has_content? '$33,800.00'

    # enter product sold at site sale
    visit site_sale_path(site_sale) 
    click_link 'Add product sold'
    select products(:one).name, from: "site_sale_line_item_product_id"
    quantity = 10
    fill_in "site_sale_line_item_quantity", with: quantity
    click_button 'Save'
    assert page.has_content? 'Product sold was successfully added'

    # add a volunteer
    click_link 'Add a Scout volunteer'
    select scouts[0].name, from: "scout_site_sale_scout_id"
    fill_in "scout_site_sale_hours_worked", with: 2
    click_button 'Save'
    assert page.has_content? 'Scout was successfully added as a volunteer for a site sale'
    assert find('td.total-credited-hours').has_content? '2'
    # $670, 10hrs is the total site sales of all ($67 per hour)
    assert find('td.total-credited-sales').has_content? '$384'

    # add a payment method
    # first delete the existing site sales cash
    site_sale.site_sale_payment_methods.delete_all
    click_link 'Add a form of payment'
    select "Site Sales cash", from: "site_sale_payment_method_account_id"
    fill_in "site_sale_payment_method_amount", with: site_sale.sales
    click_button 'Save'
    assert page.has_content? 'Form of Site Sale payment was added'

    # close site sale
    click_button "CLOSE"

    assert page.has_content? 'Site Sale was successfully closed'

    # visit income statement
    visit income_statement_path
    assert page.has_content? "Income Statement"
    # site sales = Safeway(250) + Walmart(1400)
    assert find('td.site_sale_sales').has_content? '$1,650'

    #visit balance sheet
    visit balance_sheet_path
    assert find('td.site-sales-cash').has_content? '$1,600'
    new_inventory = original_inventory - (1400.00 * (1- event.unit_commission_percentage / 100))
    assert find('td.inventory').has_content? number_to_currency(new_inventory)

    # visit home page
    visit home_path
    assert find('td.site-sales-amount').has_content? '$1,650'
  end
end