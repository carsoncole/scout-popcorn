require 'test_helper'

class ScoutTest < ActiveSupport::TestCase
  setup do
    @scout = Scout.new(first_name: 'John', last_name: 'Doe', unit_id: units(:one).id, password: 'password', email: 'willis@example.com')
  end

  test "should not save without first_name" do
    scout = Scout.new
    assert_not scout.save
    assert scout.errors[:first_name]
  end

  test "should not save without last_name" do
    scout = Scout.new
    assert_not scout.save
    assert scout.errors[:last_name]
  end

  test "should not save without email" do
    scout = Scout.new
    assert_not scout.save
    assert scout.errors[:email]
  end

  test "should save downcased email" do
    @scout.email = 'UpperCase@example.Com'
    @scout.save
    assert_equal @scout.email, 'uppercase@example.com'
  end

  test "should not save with non-unique email" do
    @scout.email = "one@example.com"
    assert_not @scout.valid?
    assert @scout.errors[:email]
  end

  test "should be is_admin if admin selected" do    
    @scout.is_unit_admin = true
    @scout.save
    assert_equal @scout.is_admin, true
    @scout.is_unit_admin = false
    @scout.save
    assert_equal @scout.is_admin, false
  end

  test "should not allow less than 1 unit admin" do
    scouts(:admin).update(is_unit_admin: false)
    assert_equal scouts(:admin).is_unit_admin, false
    scout = scouts(:unit_admin)
    scout.is_unit_admin = false
    assert_not scout.valid?
    assert scout.errors[:is_unit_admin]
  end

  test "should create an open envelope" do
    assert scouts(:one).open_envelope(events(:one)).present?
  end
end