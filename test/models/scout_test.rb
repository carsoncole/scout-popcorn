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

  test "should not save with non-unique email" do
    @scout.email = "mary@example.com"
    assert_not @scout.valid?
    assert @scout.errors[:email]
  end

  test "#activity? should be true if any activity" do
  end
end