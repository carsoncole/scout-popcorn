require 'test_helper'

class ResourcesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @resource = resources(:one)
  end

  test "should not get index when not logged in" do
    get resources_url
    assert_response :redirect
    assert_redirected_to root_path
  end

  test "should not get index when logged in" do
    sign_in(scouts(:one))
    get resources_url
    assert_response :redirect
    assert_redirected_to home_path
  end

  test "should get index when unit admin logged in" do
    sign_in(scouts(:unit_admin))
    get resources_url
    assert_response :success
  end
  
  test "should get index when take orders admin logged in" do
    sign_in(scouts(:take_orders_admin))
    get resources_url
    assert_response :success
  end

  test "should get new as unit admin" do
    sign_in(scouts(:unit_admin))
    get new_resource_url
    assert_response :success
  end

  test "should not get new as take orders admin" do
    sign_in(scouts(:take_orders_admin))
    get new_resource_url
    assert_response :redirect
    assert_redirected_to home_path
  end


  test "should create resource" do
    sign_in(scouts(:unit_admin))
    assert_difference('Resource.count') do
      post resources_url, params: { resource: { event_id: @resource.event_id, name: @resource.name, url: @resource.url } }
    end

    assert_redirected_to resources_path
  end

  test "should get edit" do
    sign_in(scouts(:unit_admin))
    get edit_resource_url(@resource)
    assert_response :success
  end

  test "should update resource" do
    sign_in(scouts(:unit_admin))
    patch resource_url(@resource), params: { resource: { event_id: @resource.event_id, name: 'New name', url: @resource.url } }
    assert_redirected_to resources_path
  end

  test "should destroy resource" do
    sign_in(scouts(:unit_admin))
    assert_difference('Resource.count', -1) do
      delete resource_url(@resource)
    end

    assert_redirected_to resources_url
  end
end
