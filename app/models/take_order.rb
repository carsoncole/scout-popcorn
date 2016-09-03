class TakeOrder < ApplicationRecord
  belongs_to :scout
  belongs_to :event
  belongs_to :purchase_order, optional: true
  has_many :products, through: :take_order_line_items
  has_many :take_order_line_items, dependent: :destroy
  validates :scout_id, :event_id, :customer_name, presence: true
  validates :customer_email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  before_save :add_to_purchase_order!, if: Proc.new { |to| to.status_changed? && to.status == 'submitted'}
  after_save :debit_stock!, if: Proc.new { |to| to.status_changed? && to.status == 'submitted'}

  STATUSES = { 
      received: { :status => :received, :name => 'Received', description: "Orders received by Scout, money not turned in"},
      submitted: { status: :submitted, :name => 'Submitted', description: "Orders submitted to Pack" },
      ordered: { :status => :ordered, :name => 'Ordered', description: "Orders that have been ordered" },
      deliver: { :status => :deliver, name: 'Deliver', description: "Orders available for delivery"},
      delivered: { :status => :delivered, :name => 'Delivered', description: "Orders delivered by Scout" }
    }

  def value
    take_order_line_items.inject(0) {|sum,line_item| sum + line_item.value}
  end

  def self.submitted
    where.not(status: 'received')
  end

  def self.received
    where(status: 'received')
  end

  def received?
    status == 'received'
  end

  def self.sales_by_scout_and_event(event)
    event.take_orders.joins(:take_order_line_items).group(:scout_id).sum(:value)
  end

  def money_received_by
    Scout.find(money_received_by_id).name unless money_received_by_id.blank?
  end


  private

  def add_to_purchase_order!
    self.purchase_order_id = event.open_take_order_purchase_order.id
  end

  def debit_stock!
    take_order_line_items.each do |line_item|
      available_stock = scout.unit.stocks.where(product_id: line_item.product_id, location: 'take orders').first
      if available_stock
        available_stock.update(quantity: available_stock.quantity - line_item.quantity, location: 'take orders')
      else
        scout.unit.stocks.create(product_id: line_item.product_id, quantity: - line_item.quantity, location: 'take orders')
      end
    end
  end

end
