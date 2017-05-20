require 'test_helper'

class ScoutMailerTest < ActionMailer::TestCase

  # enable email sending
  setup do
    units(:one).update(send_email_on_registration: true)
    @scout = scouts(:one)
  end


  test "registration" do
    # create the email and store for testing
    email = ScoutMailer.registration(@scout)

    # send and check queue
    assert_emails 1 do
      email.deliver_now
    end

    # test the body
    assert_equal ['from_email@example.com'], email.from
    assert_equal ["unit_admin@example.com", "admin@example.com"], email.to
    assert_equal "#{Rails.configuration.application_name} registration by: #{@scout.name}", email.subject
    assert_equal read_fixture('registration').join, email.body.to_s

  end

  test "you are registered email" do
    # create the email and store for testing
    email = ScoutMailer.you_are_registered(@scout)

    # send and check queue
    assert_emails 1 do
      email.deliver_now
    end

    # test the body
    assert_equal ['from_email@example.com'], email.from
    assert_equal ["sam@example.com"], email.to
    assert_equal "Welcome to #{Rails.configuration.application_name}", email.subject
    assert_equal read_fixture('you_are_registered').join, email.body.to_s
  end

end