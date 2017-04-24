require 'test_helper'

class ScoutsControllerTest < ActionDispatch::IntegrationTest
  setup do
    post '/sessions', params: { email: 'mary@example.com', password: 'password'}
  end


  test "should show multiple possible events in profile edit" do
    event = Event.create(name: 'Some Event', is_active: true, unit_id: units(:one).id)
    scout = scouts(:one)
    get edit_scout_url(scout)
    assert_response :success
    assert_select ".event_selection", 1
  end

  test "scout profile should not allow editing event if only one available" do
    scout = scouts(:one)
    get edit_scout_url(scout)
    assert_response :success
    assert_select ".event_selection", false
  end

  test "should successfully login and redirect" do
    follow_redirect!
    assert_select "span.event-name", "Popcorn 2017"
  end

  # test "should get new" do
  #   get new_scout_url
  #   assert_response :success
  # end

  # test "should create scout" do
  #   assert_difference('Scout.count') do
  #     post scouts_url, params: { scout: {  } }
  #   end

  #   assert_redirected_to scout_url(Scout.last)
  # end

  # test "should show scout" do
  #   get scout_url(@scout)
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get edit_scout_url(@scout)
  #   assert_response :success
  # end

  # test "should update scout" do
  #   patch scout_url(@scout), params: { scout: {  } }
  #   assert_redirected_to scout_url(@scout)
  # end

  # test "should destroy scout" do
  #   assert_difference('Scout.count', -1) do
  #     delete scout_url(@scout)
  #   end

  #   assert_redirected_to scouts_url
  # end
end
