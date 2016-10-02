require 'test_helper'

class ScoutPrizeSelectionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get scout_prize_selections_index_url
    assert_response :success
  end

end
