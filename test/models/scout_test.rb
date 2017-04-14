require 'test_helper'

class ScoutTest < ActiveSupport::TestCase
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
end