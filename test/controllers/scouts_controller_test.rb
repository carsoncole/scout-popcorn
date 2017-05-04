require 'test_helper'

class ScoutsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @scout = scouts(:one)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should create scout" do
    assert_difference('Scout.count') do
      post scouts_url, params: { scout: { unit_id: units(:one).id, first_name: 'John', last_name: 'Example', email: 'test@example.com', password: 'password' } }
    end
    assert_redirected_to root_path
  end

  test "should not allow scout signups without units" do
    Unit.destroy_all
    get signup_path
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should successfully login and redirect" do
    sign_in(scouts(:one))
    follow_redirect!
    assert_select "span.event-name", "Popcorn 2017"
  end

  test "scout profile should not allow editing event if only one available" do
    sign_in(scouts(:one))
    scout = scouts(:one)
    get edit_scout_url(scout)
    assert_response :success
    assert_select ".event_selection", false
  end

 test "should show #active unit" do
    get signup_path
    assert_select "#scout_unit_id" do |element|
      assert_select element, "option", 3
    end
    assert_select "option", "Pack 100"
    assert_select "option", "Troop 100"
  end

  test "should not allow scout with non-unique email" do
    get signup_path
    assert_difference('Scout.count', 0) do
      post scouts_url, params: { scout: { unit_id: units(:one).id, first_name: 'John', last_name: 'Example', email: 'mary@example.com', password: 'password' } }
    end
    assert_equal css_select('ul.errors>li').last.content, 'Email has already been taken'
  end

  test "should show scout" do
    sign_in(scouts(:one))
    get scout_url(@scout)
    assert_response :success
  end

  test "should get edit" do
    sign_in(scouts(:one))
    get edit_scout_url(@scout)
    assert_response :success
  end

  test "should not allow non-admins to #index" do
    sign_in(scouts(:one))
    get scouts_url
    assert_response :redirect
    follow_redirect!
    assert_select ".my-sales"
  end

  test "should not update scout when other scouts do it" do
    sign_in(scouts(:two))
    patch scout_url(@scout), params: { scout: { first_name: 'new name'  } }
    assert_response :success
    assert flash[:notice], 'Scout was not updated.'
  end  

  # Admin

  test "should show all scouts" do
    sign_in(scouts(:unit_admin))
    get scouts_url
    assert_response :success

    sign_in(scouts(:take_orders_admin))
    get scouts_url
    assert_response :success

    sign_in(scouts(:site_sales_admin))
    get scouts_url
    assert_response :success
  end

  test "should allow destroy if no activity" do
    sign_in(scouts(:unit_admin))
    scout = scouts(:no_activity)
    assert_difference('Scout.count', -1) do
      delete scout_url scout
    end
  end

  test "should not allow destroy if activity" do
    sign_in(scouts(:unit_admin))
    scout = scouts(:one)
    assert_difference('Scout.count', 0) do
      delete scout_url scout
    end
  end

  test "should update scout when scout does it" do
    sign_in(@scout)
    patch scout_url(@scout), params: { scout: { first_name: 'new name'  } }
    assert_redirected_to scout_url(@scout)
    assert flash[:notice], 'Scout was successfully updated.'
  end

  test "should update scout when unit_admin does it" do
    sign_in(scouts(:unit_admin))
    patch scout_url(@scout), params: { scout: { first_name: 'new name'  } }
    assert_redirected_to scout_url(@scout)
    assert flash[:notice], 'Scout was successfully updated.'
  end

end