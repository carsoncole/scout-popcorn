require 'test_helper'

class PrizesControllerTest < ActionDispatch::IntegrationTest  
  include ActionView::Helpers::NumberHelper

  setup do
    @prize = prizes(:one)
  end

  test "should get index " do
    sign_in(scouts(:one))
    get prizes_url
    assert_response :success
  end

  test "should not get new" do
    sign_in(scouts(:one))
    get new_prize_url
    assert_response :redirect
    assert_redirected_to home_path
  end

  test "should show available credits" do
    sign_in(scouts(:one))
    scout = scouts(:one)
    event = events(:one)
    get prizes_url
    assert_select ".council.remaining-sales-credits", number_to_currency(scout.prize_cart(event).available_sales_credits('Council'), precision: 2)
  end

  test "should show used credits" do
    sign_in(scouts(:one))
    scout = scouts(:one)
    event = events(:one)
    get prizes_url
    assert_select ".council.used-credits", number_to_currency(scout.prize_cart(event).sales_credits_used('Council'), precision: 2)
  end

  # Admin

  test "should get admin index" do
    sign_in(scouts(:prizes_admin))
    get prizes_url
    assert_response :success
  end

  test "should get new" do
    sign_in(scouts(:prizes_admin))
    get new_prize_url
    assert_response :success
  end

  test "should create prize" do
    sign_in(scouts(:prizes_admin))
    assert_difference('Prize.count') do
      post prizes_url, params: { prize: { event_id: @prize.event_id, sales_amount: @prize.sales_amount, source: @prize.source, name: 'Prize name' } }
    end

    assert_redirected_to prize_url(Prize.last)
  end

  test "should show prize" do
    sign_in(scouts(:prizes_admin))
    get prize_url(@prize)
    assert_response :success
  end

  test "should get edit" do
    sign_in(scouts(:prizes_admin))
    get edit_prize_url(@prize)
    assert_response :success
  end

  test "should update prize" do
    sign_in(scouts(:prizes_admin))
    patch prize_url(@prize), params: { prize: { sales_amount: @prize.sales_amount, name: 'Another name' } }
    assert_redirected_to prize_url(@prize)
  end

  test "should not destroy prize since used" do
    sign_in(scouts(:prizes_admin))
    assert_difference('Prize.count', 0) do
      delete prize_url(@pri ze)
    end

    assert_redirected_to prizes_url
  end

  test "should destroy unusued prize" do
    sign_in(scouts(:prizes_admin))
    prize = prizes(:four)
    assert_difference('Prize.count', -1) do
      delete prize_url(prize)
    end

    assert_redirected_to prizes_url
  end

end
