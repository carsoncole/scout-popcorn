require 'test_helper'

class ScoutsControllerTest < ActionDispatch::IntegrationTest
  setup do
    post '/sessions', params: { email: 'mary@example.com', password: 'password'}
    @scout = scouts(:one)
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

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should show #active unit" do
    get signup_path
    assert_select "#scout_unit_id" do |element|
      assert_select element, "option", 2
    end
    assert_select "option", "Pack 100"
  end

  test "should not allow scout with non-unique email" do
    get signup_path
    assert_difference('Scout.count', 0) do
      post scouts_url, params: { scout: { unit_id: units(:one).id, first_name: 'John', last_name: 'Example', email: 'mary@example.com', password: 'password' } }
    end
    assert_equal css_select('ul.errors>li').last.content, 'Email has already been taken'
  end

  test "should create scout" do
    assert_difference('Scout.count') do
      post scouts_url, params: { scout: { unit_id: units(:one).id, first_name: 'John', last_name: 'Example', email: 'test@example.com', password: 'password' } }
    end

    assert_redirected_to root_path
  end

  test "should show scout" do
    get scout_url(@scout)
    assert_response :success
  end

  test "should get edit" do
    get edit_scout_url(@scout)
    assert_response :success
  end

  test "should update scout" do
    # patch scout_url(@scout), params: { scout: {  } }
    # assert_redirected_to scout_url(@scout)
  end
end
