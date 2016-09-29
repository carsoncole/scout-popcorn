class Envelope < ApplicationRecord
  belongs_to :scout
  belongs_to :event
  has_many :take_orders

  validates :scout_id, :event_id, presence: true

  after_initialize :init
  after_save :process_if_closed!, if: Proc.new {|e| e.status == 'Closed' && e.status_changed? }

  def init
    self.status ||= 'Open'
  end

  def self.open
    where(status: 'Open')
  end

  def self.closed
    where(status: 'Closed')
  end

  def closed?
    status == 'Closed'
  end

  def open?
    status == 'Open'
  end

  def name
    scout.name + ' Envelope #' + id.to_s
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
end