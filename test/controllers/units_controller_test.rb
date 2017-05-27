require 'test_helper'

class UnitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @unit = units(:one)
  end

  test "should get new" do
    get new_unit_url
    assert_response :success
  end

  test "should create unit" do
    assert_difference('Unit.count') do
      assert_difference('Scout.count') do
        post units_url, params: { unit: { name: 'Some Unit' }, scout: {first_name: 'Name', last_name: 'Name', email: 'someemail2@example.com', password: 'password' } }
      end
    end

    assert flash[:notice], 'Unit was successfully created. Login to continue.'
    assert_redirected_to root_path
  end

  test "should not create unit with invalid scout" do
    assert_difference('Unit.count') do
      assert_difference('Scout.count') do
        post units_url, params: { unit: { name: 'Some Unit' }, scout: {first_name: 'Name', last_name: 'Name', email: 'someemail2@example.com', password: 'password' } }
      end
    end

    assert flash[:notice], 'Unit was successfully created. Login to continue.'
    assert_redirected_to root_path
  end

  test "should not create unit without a name" do
    assert_difference('Unit.count', 0) do
      post units_url, params: { unit: { name: ''}, scout: {first_name: 'Name', last_name: 'Name', email: 'someemail@example.com', password: 'password' } }
    end

    assert_select "div#error_explanation ul li", "Name can't be blank"
  end

  test "should not create unit without a first name " do
    assert_difference('Unit.count', 0) do
      post units_url, params: { unit: { name: 'adfaf'}, scout: {last_name: 'Name', email: 'someemail@example.com', password: 'password' } }
    end

    assert_select "div#error_explanation ul li", "First name can't be blank"
  end

  test "should not show unit" do
    get unit_url(@unit)
    assert_response :redirect
    assert_redirected_to root_url
  end

  test "should not get edit" do
    get edit_unit_url(@unit)
    assert_response :redirect
    assert_redirected_to root_url
  end

  test "should not update unit" do
    patch unit_url(@unit), params: { unit: {  } }
    assert_response :redirect
    assert_redirected_to root_url
  end

  test "should not update unit without name" do
    sign_in(scouts(:unit_admin))
    patch unit_url(@unit), params: { unit: { name: nil  } }
    assert_response :success
    assert_select "div#error_explanation ul li", "Name can't be blank"
  end

  test "should not destroy unit" do
    assert_difference('Unit.count', 0) do
      delete unit_url @unit
    end

    assert_redirected_to root_url
  end

  # Non-Unit Admin
  test "should not update unit as take orders admin" do
    sign_in(scouts(:take_orders_admin))
    patch unit_url(@unit), params: { unit: {  } }
    assert_response :redirect
    assert_redirected_to home_url
  end

  test "should not destroy unit as take orders admin" do
    sign_in(scouts(:take_orders_admin))
    assert_difference('Unit.count', 0) do
      delete unit_url @unit
    end

    assert_redirected_to home_url
  end

  test "should not destroy unit as financial admin" do
    sign_in(scouts(:financial_admin))
    assert_difference('Unit.count', 0) do
      delete unit_url @unit
    end

    assert_redirected_to home_url
  end


  # Unit Admin

  test "should show unit" do
    sign_in(scouts(:unit_admin))
    get unit_url(@unit)
    assert_response :success
  end

  test "should get edit" do
    sign_in(scouts(:unit_admin))
    get edit_unit_url(@unit)
    assert_response :success
  end

  test "should update unit" do
    sign_in(scouts(:unit_admin))
    patch unit_url(@unit), params: { unit: { name: 'New name'  } }
    assert_response :redirect
    assert_redirected_to unit_url
  end

  test "should destroy unit" do
    sign_in(scouts(:unit_admin))
    assert_difference('Unit.count', -1) do
      delete unit_url @unit
    end
    assert flash[:notice], 'Unit was successfully destroyed.'
    assert_redirected_to root_url
  end  


end
