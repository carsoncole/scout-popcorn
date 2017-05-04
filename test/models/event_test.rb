require 'test_helper'

class EventTest < ActiveSupport::TestCase
  def setup
    @event = Event.new(name: 'Some Event 20XX', unit_commission_percentage: 30, online_commission_percentage: 30, number_of_top_sellers: 10, unit: units(:one))
  end

  test "valid event is created" do
    assert @event.valid?
  end

  test "event is not valid without name" do
    @event.name = nil
    assert @event.invalid?
  end

  test "event is not valid with out-of-range commissions" do
    @event.unit_commission_percentage, @event.online_commission_percentage = 200
    assert @event.invalid?
    assert_equal [:unit_commission_percentage, :online_commission_percentage].sort, @event.errors.keys.sort
  end

  test "scout has an assigned event on creating new event" do
    scout = scouts(:one)
    assert_equal scout.event_id, events(:one).id
    new_event = Event.create(name: 'Popcorn 2020', unit_id: scout.unit_id, is_active: true)
    assert new_event.is_active

    assert_equal scout.reload.event_id, new_event.id
  end

  test "destroying events results in nil events for scouts" do
    scout = scouts(:one)
    assert_not_nil scout.event_id
    events(:one).destroy
    scout.reload
    assert_nil scout.event_id
  end

  test "scouts with nil events are assigned on events made active" do
    scout = scouts(:one)
    scout.update(event_id: nil)
    @event.is_active = true
    @event.save
    scout.reload
    assert_not_nil scout.event_id
  end

  test "new event should have necessary accounts" do 
    @event.save
    event_accounts_ordered = @event.accounts.order(:name).map {|a| a.name }

    assert_equal event_accounts_ordered,
      [ 'BSA bank account',
        'Due from customers',
        'Due to BSA',
        'Inventory',
        'Product due to customers',
        'Site Sales cash',
        'Take Orders cash',
        'Third Party account',
        'Unit bank account'
       ]
  end

  test "should add default products" do
    @event.save
    assert_empty @event.products
    assert @event.create_default_products!('Chief Seattle Council')
    assert @event.products.present?
  end

  test "should only allow one active event" do
    event = events(:one)
    assert event.is_active
    
    # create new
    @event.is_active = true
    @event.save
    assert_not event.reload.is_active
    assert @event.is_active
    assert_empty event.unit.events.active.where.not(id: @event.id)
    
    # update 
    event.is_active = true
    event.save
    assert event.is_active
    assert_not @event.reload.is_active
  end
end