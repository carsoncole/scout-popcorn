require 'test_helper'

class PrizeCartFlowTest < Capybara::Rails::TestCase
  include ActionView::Helpers::NumberHelper

  test "should select and order and unorder prizes" do
    capybara_login(scouts(:one)) 
    event = events(:one)
    prize_cart = scouts(:one).prize_cart(event) 

    visit prizes_path
    visit prize_cart_path(prize_cart)
    find('.summer-camp-100-credit').click # Remove
    click_button 'Remove'
    click_link 'View Prizes'
  
    assert find('span.remaining-sales-credits.unit').has_content? '$1,542.00'
    find('.summer-camp-50-credit').click 
    assert find('span.remaining-sales-credits.unit').has_content? '$1,242.00'

    visit prize_cart_path(prize_cart) 
    assert has_button? 'Order Prizes'
    click_button 'Order Prizes'
    assert page.has_content? 'Ordered'
    assert has_button? 'Reopen Order'
    click_button 'Reopen Order'
    assert has_button? 'Order Prizes'
  end
end