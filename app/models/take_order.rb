class TakeOrder < ApplicationRecord
  belongs_to :scout
  belongs_to :event
  belongs_to :purchase_order, optional: true
  has_many :products, through: :line_items
  has_many :line_items, dependent: :destroy
  validates :scout_id, :event_id, presence: true
  before_save :add_to_purchase_order!, if: Proc.new { |to| to.status_changed? && to.status == 'paid'}

  STATUSES = [
      { :status => :open, :name => 'Open' },
      { :status => :setup, :name => 'Paid' },
      { :status => :ordered, :name => 'Ordered' },
      { :status => :deliver, name: 'Deliver'},
      { :status => :delivered, :name => 'Delivered' }
    ]

  def value
    line_items.inject(0) {|sum,line_item| sum + line_item.value}
  end

  def self.paid
    where.not(status: 'open')
  end

  def self.open
    where(status: 'open')
  end

  def self.sales_by_scout_and_event(event)
    event.take_orders.joins(:line_items).group(:scout_id).sum(:value)
  end

  def money_received_by
    Scout.find(money_received_by_id).name unless money_received_by_id.blank?
  end


  private

  def add_to_purchase_order!
    self.purchase_order_id = event.open_take_order_purchase_order.id
  end
end
