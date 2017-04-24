require 'test_helper'

class ResourceTest < ActiveSupport::TestCase
  def setup
    @resource = Resource.new(name: 'Some Event 20XX', url: "http://example.com", event_id: events(:one).id)
  end

  test "for invalid URL" do
    @resource.url = 'something'
    assert @resource.invalid?
    assert_equal [:url].sort, @resource.errors.keys.sort
  end
end