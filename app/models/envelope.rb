class Envelope < ApplicationRecord
  belongs_to :scout
  belongs_to :event
  has_many :take_orders

  validates :scout_id, :event_id, presence: true

  after_initialize :init
  before_save :process_if_closed!, if: Proc.new {|e| e.status == 'Closed' && e.status_changed? }
  before_save :reverse_if_reopened!, if: Proc.new {|e| e.status == 'Open' && e.status_changed? }
  before_save :process_if_picked_up!, if: Proc.new {|e| e.status == 'Picked Up' && e.status_changed? }

  def init
    self.status ||= 'Open'
  end

  def self.open
    where(status: 'Open')
  end

  def self.closed
    where(status: 'Closed')
  end

  def open?
    status == 'Open'
  end

  def closed?
    status == 'Closed'
  end

  def self.picked_up
    where(status: 'Picked Up')
  end

  def picked_up?
    status == 'Picked Up'
  end

  def name
    scout.name + ' Take Order Envelope #' + id.to_s
  end

  def value
    TakeOrderLineItem.where(take_order_id: take_orders.map{|to| to.id}).inject(0) {|sum,line_item| sum + line_item.value}
  end

  private

  def process_if_closed!
    take_orders.each do |take_order|
      take_order.update(status: :submitted)
    end
  end

  def process_if_picked_up!
    take_orders.each do |take_order|
      take_order.update(status: :picked_up)
    end
  end

  def reverse_if_reopened!
    take_orders.each do |take_order|
      take_order.update(status: 'in hand')
    end    
  end
end