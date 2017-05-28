require 'test_helper'

class EnvelopesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @envelope = envelopes(:one)
  end

  test "should not get index without sign_in" do
    get envelopes_url
    assert_redirected_to controller: 'sessions', action: 'new'
  end

  test "should get index" do
    sign_in(scouts(:take_orders_admin))
    get envelopes_url
    assert_response :success
  end

  test "should get show as scout" do
    sign_in(scouts(:one))
    get envelope_url(@envelope)
    assert_response :success
  end

  test "should get new as admin" do
    sign_in(scouts(:take_orders_admin))
    get new_envelope_url
    assert_response :success
  end

end