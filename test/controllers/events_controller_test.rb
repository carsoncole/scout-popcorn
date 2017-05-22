require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @event = events(:one)
  end
  
  test 'should not get index without sign_in' do
    get events_url
    assert_redirected_to controller: 'sessions', action: 'new'
  end

  test 'should not get edit for non-logins' do
    get edit_event_url(@event)
    assert_response :redirect
    assert_redirected_to root_url
  end

  test 'should not get index' do
    sign_in(scouts(:one))
    get events_url
    assert_response :redirect
    assert_redirected_to home_path
  end

  test 'should not get new' do
    sign_in(scouts(:one))
    get new_event_url
    assert_redirected_to controller: 'home', action: 'index'
  end

  test 'should not create event' do
    sign_in(scouts(:one))
    assert_difference('Event.count', 0) do
      post events_url, params: { event: { name: @event.name, unit_id: @event.unit_id } }
    end

    assert_redirected_to home_url
  end

  test 'should not show event' do
    sign_in(scouts(:one))
    get event_url(@event)
    assert_redirected_to home_url
  end

  test 'should not get edit' do
    sign_in(scouts(:one))
    get edit_event_url(@event)
    assert_redirected_to home_url
  end

  test 'should not update event' do
    sign_in(scouts(:one))
    patch event_url(@event), params: { event: { name: @event.name, unit_id: @event.unit_id } }
    assert_redirected_to home_url
  end

  test 'should not destroy event' do
    sign_in(scouts(:one))
    assert_difference('Event.count', 0) do
      delete event_url(@event)
    end

    assert_redirected_to home_url
  end

  # Admin

  test 'should get index' do
    sign_in(scouts(:unit_admin))
    get events_url
    assert_response :success
  end

  test 'should not get index for other admins' do
    sign_in(scouts(:take_orders_admin))
    get events_url
    assert_response :redirect
    assert_redirected_to home_path
  end

  test 'should get new' do
    sign_in(scouts(:unit_admin))
    get new_event_url
    assert_response :success
  end

  test 'should create event' do
    sign_in(scouts(:unit_admin))
    assert_difference('Event.count', 1) do
      post events_url, params: { event: { name: @event.name, unit_id: @event.unit_id } }
    end

    assert_redirected_to events_url
  end

  test 'should show event' do
    sign_in(scouts(:unit_admin))
    get event_url(@event)
    assert_redirected_to events_url
  end

  test 'should get edit' do
    sign_in(scouts(:unit_admin))
    get edit_event_url(@event)
    assert_response :success
  end

  test 'should update event' do
    sign_in(scouts(:unit_admin))
    patch event_url(@event), params: { event: { name: @event.name, unit_id: @event.unit_id } }
    assert_redirected_to events_url
  end

  test 'should destroy event' do
    sign_in(scouts(:unit_admin))
    assert_difference('Event.count', -1) do
      delete event_url(@event)
    end

    assert_redirected_to events_url
  end

  test 'should not get edit for other admins' do
    sign_in(scouts(:take_orders_admin))
    get edit_event_url(@event)
    assert_response :redirect
    assert_redirected_to home_url
  end

end
