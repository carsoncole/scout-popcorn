class TakeOrder < ApplicationRecord
  belongs_to :scout
  belongs_to :event
  belongs_to :purchase_order, optional: true
  belongs_to :payment_method
  belongs_to :account
  has_many :products, through: :take_order_line_items
  before_destroy :credit_stock!, if: Proc.new { |to| to.submitted? }
  has_many :take_order_line_items, dependent: :destroy
  validates :scout_id, :event_id, :customer_name, :account_id, presence: true
  validates :customer_email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }, if: Proc.new {|to| to.customer_email.present? }
  before_save :add_to_purchase_order!, if: Proc.new { |to| to.status_changed? && to.status == 'submitted'}
  after_save :debit_stock!, if: Proc.new { |to| to.status_changed? && to.status == 'submitted'}
  after_save :credit_ledger!, if: Proc.new { |to| to.status_changed? && to.status == 'submitted'}
  after_save :send_receipt!, if: Proc.new { |to| to.customer_email.present? && to.status_changed? && to.status == 'submitted' && to.receipt_sent_at.blank? }


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

  def submitted?
    status == 'submitted'
  end

  def self.received
    where(status: 'received')
  end

  def received?
    status == 'received'
  end

  def self.scout_sales(scout, event)
    scout.take_orders.where(event_id: event.id).joins(:take_order_line_items).sum(:value)
  end

  def self.sales_by_scout_and_event(event)
    event.take_orders.where("take_orders.status <> ?", "received").joins(:take_order_line_items).group(:scout_id).sum(:value)
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
      new_stock_entry = Stock.new(unit_id: self.event.unit_id, product_id: line_item.product_id, location: 'take orders', quantity: -line_item.quantity, take_order_id: self.id, description: "Take order ##{line_item.take_order_id}", created_by: 999)
      new_stock_entry.save
    end
  end

  def credit_stock!
    take_order_line_items.each do |line_item|
      new_stock_entry = Stock.new(unit_id: self.event.unit_id, product_id: line_item.product_id, location: 'take orders', quantity: line_item.quantity, take_order_id: self.id, description: "Take order ##{line_item.take_order_id} credited back", created_by: 999)
      new_stock_entry.save
    end
  end

  def send_receipt!
    TakeOrderMailer.receipt(self).deliver_now
    self.update(receipt_sent_at: Time.current)
  end

  def credit_ledger!
    take_order_line_items.each do |line_item|
      unit = self.event.unit
      Ledger.create(account_id: account_id, amount: line_item.value, date: Date.current, description: "Take Order: #{self.id}")
    end
  end

end
