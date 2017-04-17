require 'test_helper'
require 'minitest/autorun'

class UnitTest < ActiveSupport::TestCase
  test "should not save without name" do
    unit = Unit.new
    assert_not unit.save
    assert unit.errors[:name].any?
  end

  test "should require valid or no email" do
    unit = Unit.new(treasurer_email: 'something')
    assert_not unit.save
    assert unit.errors[:treasurer_email].any?
  end

  test "should require name if email" do
    unit = Unit.new(treasurer_email: 'something')
    assert_not unit.save
    assert unit.errors[:treasurer_first_name].any?
  end
end
