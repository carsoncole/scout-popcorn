class TakeOrder < ApplicationRecord
  belongs_to :scout
  belongs_to :event
  belongs_to :purchase_order, optional: true
  belongs_to :payment_method
  belongs_to :account, foreign_key: :payment_account_id
  belongs_to :envelope
  has_many :products, through: :take_order_line_items
  before_destroy :credit_stock!, if: Proc.new { |to| to.submitted? }
  has_many :take_order_line_items, dependent: :destroy
  validates :scout_id, :event_id, :customer_name, :payment_account_id, presence: true
  validates :customer_email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }, if: Proc.new {|to| to.customer_email.present? }
  before_save :add_to_purchase_order!, if: Proc.new { |to| to.status_changed? && to.status == 'submitted'}
  after_save :debit_stock!, if: Proc.new { |to| to.status_changed? && to.status == 'submitted'}
  after_save :register_money_received_and_product_due!, if: Proc.new { |to| to.status_changed? && to.status == 'submitted'}
  after_save :send_receipt!, if: Proc.new { |to| to.customer_email.present? && to.status_changed? && to.status == 'submitted' && to.receipt_sent_at.blank? }
  before_create :assign_to_envelope!

  STATUSES = { 
      in_hand: { :status => :in_hand, :name => 'In Hand', description: "Order that a Scout has received"},
      turned_in: { status: :turned_in, :name => 'Turned In', description: "Orders submitted to Pack" },
      ordered: { :status => :ordered, :name => 'Ordered', description: "Orders that have been ordered" },
      deliver: { :status => :deliver, name: 'Deliver', description: "Orders available for delivery"},
      delivered: { :status => :delivered, :name => 'Delivered', description: "Orders delivered by Scout" }
    }

  def value
    take_order_line_items.inject(0) {|sum,line_item| sum + line_item.value}
  end

  def self.received
    where.not(status: 'received')
  end

  def self.loose
    where(envelope_id: nil)
  end

  def self.loose?
    envelope_id.nil?
  end

  def self.enveloped
    where.not(envelope_id: nil)
  end

  def self.enveloped?
    !envelope_id.nil?
  end


  def received?
    status == 'received'
  end

  def self.in_hand
    where.not(status: 'received')
  end

  def in_hand?
    status == 'received'
  end

  def self.turned_in
    where(status: 'submitted')
  end

  def turned_in?
    status == 'submitted'
  end

  def self.submitted
    where(status: 'submitted')
  end

  def submitted?
    status == 'submitted'
  end

  def self.sales(event)
    where(event_id: event.id).inject(0){|sum,t| sum + t.take_order_line_items.sum(:value) }
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

  def register_money_received_and_product_due!
    take_order_line_items.each do |line_item|
      unit = self.event.unit
      Ledger.create(take_order_id: self.id, account_id: payment_account_id, amount: line_item.value, date: Date.current, description: "Take Order submitted")
      product_due_to_customers_account = event.unit.accounts.where(name: 'Product due to Customers').first
      Ledger.create(take_order_id: self.id, account_id: product_due_to_customers_account.id, amount: line_item.value * Product::WHOLESALE_COST_PERCENTAGE, date: Date.current, description: "Take Order submitted")
    end
  end

  def assign_to_envelope!
    return if self.envelope_id
    if scout.open_envelope?(self.event)
      self.envelope_id = scout.open_envelope(self.event).id
    else
      new_envelope = scout.envelopes.create(event_id: self.event_id)
      self.envelope_id = new_envelope.id
    end
  end

end
