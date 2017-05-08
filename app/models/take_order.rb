class TakeOrder < ApplicationRecord
  belongs_to :purchase_order, optional: true
  belongs_to :account, foreign_key: :payment_account_id
  belongs_to :envelope
  has_many :products, through: :take_order_line_items
  has_many :take_order_line_items, dependent: :destroy
  has_many :ledgers
  
  validates :scout_id, :event_id, :customer_name, :payment_account_id, presence: true
  validates :customer_email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }, if: Proc.new {|to| to.customer_email.present? }
  validate :check_scout_id_matches_envelope_scout_id
  
  before_save :add_to_purchase_order!, if: Proc.new { |to| to.status_changed? && to.status == 'submitted'}
  before_save :send_receipt!, if: Proc.new { |to| to.customer_email.present? && to.status_changed? && to.status == 'submitted' && to.receipt_sent_at.blank? }
  # before_save :debit_stock!, if: Proc.new { |to| to.status_changed? && to.status == 'submitted'}
  before_save :register_money_received_and_product_due!, if: Proc.new { |to| to.status_changed? && to.status == 'submitted'}
  before_save :credit_product_due!, if: Proc.new { |to| to.status_changed? && to.status == 'picked_up'}
  before_save :debit_stock_for_pickup!, if: Proc.new { |to| to.status_changed? && to.status == 'picked_up'}
  before_save :credit_stock_for_reversed_pickup!, if: Proc.new { |to| to.status_changed? && to.status_was == :picked_up}

  before_save :remove_from_purchase_order!, if: Proc.new {|t| !t.new_record? && t.status_changed? && t.status == 'in hand'}
  before_save :credit_stock!, if: Proc.new { |to| !to.new_record? && to.status_changed? && to.status == 'in hand'}
  before_save :reverse_money_received_and_product_due!, if: Proc.new { |to| !to.new_record? && to.status_changed? && to.status == 'in hand'}
  before_create :assign_to_envelope!
  before_destroy :credit_stock!, if: Proc.new { |to| to.submitted? }
  
  def value
    take_order_line_items.inject(0) {|sum,line_item| sum + line_item.value}
  end

  def value_without_pack_donations
    take_order_line_items.joins(:product).where("products.is_pack_donation IS NULL OR ?",false).inject(0) {|sum,line_item| sum + line_item.value}
  end

  def self.in_hand
    where.(status: 'in hand')
  end

  def in_hand?
    status == 'in hand'
  end

  def self.turned_in
    where(status: 'submitted')
  end

  def turned_in?
    status == 'submitted'
  end

  def ordered?
    status == 'ordered'
  end

  def ordered
    where(status: 'ordered')
  end

  def self.submitted
    where(status: 'submitted')
  end

  def submitted?
    status == 'submitted'
  end

  def self.delivered
    where(status: 'delivered')
  end

  def delivered?
    status == 'delivered'
  end

  def products_and_quantities
    take_order_line_items.joins(:product).map{|toli| toli.product.name + ' (' + toli.quantity.to_s + ')' }.join(', ')
  end

  # def self.sales(event, is_turned_in=nil)
  #   if is_turned_in
  #     joins(:envelope).where("envelopes.event_id =?", event.id).where.not(status: 'in hand').inject(0){|sum,t| sum + t.take_order_line_items.sum(:value) }
  #   elsif is_turned_in == false
  #     joins(:envelope).where("envelopes.event_id = ?",event.id).where(status: 'in hand').inject(0){|sum,t| sum + t.take_order_line_items.sum(:value) } 
  #   else
  #     joins(:envelope).where("envelopes.event_id = ?", event.id).inject(0){|sum,t| sum + t.take_order_line_items.sum(:value) } 
  #   end
  # end

  def self.scout_sales(scout, event)
    scout.envelopes.joins(take_orders: :take_order_line_items).where("envelopes.event_id =?", event.id).sum(:value)
  end

  def self.sales_by_scout_and_event(event)
    event.take_orders.where("take_orders.status <> ?", "in hand").joins(:take_order_line_items).group(:scout_id).sum(:value)
  end

  def money_received_by
    Scout.find(money_received_by_id).name unless money_received_by_id.blank?
  end

  def reprocess_money_received_and_product_due!
    reverse_money_received_and_product_due!
    register_money_received_and_product_due!
  end

  private

  def add_to_purchase_order!
    self.purchase_order_id = event.open_take_order_purchase_order.id
  end

  def remove_from_purchase_order!
    self.purchase_order_id = nil
  end

  def debit_stock!
    date = self.envelope.money_received_at.blank? ? self.envelope.created_at : self.envelope.money_received_at
    take_order_line_items.each do |line_item|
      new_stock_entry = Stock.new(unit_id: self.event.unit_id, product_id: line_item.product_id, location: 'take orders', quantity: -line_item.quantity, take_order_id: self.id, description: "Take order ##{line_item.take_order_id}", date: date, created_by: 999)
      new_stock_entry.save
    end
  end

  def credit_stock!
    take_order_line_items.each do |line_item|
      existing_stock_entry = Stock.where(take_order_id: self.id).first
      existing_stock_entry.destroy if existing_stock_entry
    end
  end

  def send_receipt!
    TakeOrderMailer.receipt(self).deliver_now
    self.receipt_sent_at =  Time.current
  end

  def register_money_received_and_product_due!
    # date = self.money_received_at.blank? ? self.created_at : self.money_received_at
    date = self.envelope.money_received_at.blank? ? self.envelope.created_at : self.envelope.money_received_at
    take_order_line_items.each do |line_item|
      unit = self.event.unit      
      Ledger.create(take_order_id: self.id, account_id: payment_account_id, amount: line_item.value, date: date, description: "Take Order submitted", is_take_order_product_related: true)
      
      if line_item.product.physical?
        product_due_to_customers_account = event.accounts.where(name: 'Product due to Customers').first
        Ledger.create(take_order_id: self.id, account_id: product_due_to_customers_account.id, amount: line_item.value * event.bsa_wholesale_percentage, date: date, description: "Take Order submitted", line_item_id: line_item.id, is_take_order_product_related: true)
      end
    end
  end

  def reverse_money_received_and_product_due!
    existing_ledger = Ledger.where(take_order_id: self.id, is_take_order_product_related: true).destroy_all
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

  def check_scout_id_matches_envelope_scout_id
    if envelope && scout_id != envelope.scout_id
      errors.add(:scout_id, "must match the Scout on the Envelope.")
    end
  end

  def credit_product_due!
    product_due_to_customers_account = event.accounts.where(name: 'Product due to Customers').first
    product_due_ledgers = Ledger.where(take_order_id: self.id, is_take_order_product_related: true, account_id: product_due_to_customers_account.id)
    product_due_ledgers.each do |ledger|
      Ledger.create(take_order_id: self.id, account_id: product_due_to_customers_account.id, amount: -ledger.amount, date: Date.today, description: "Take Order picked up", line_item_id: ledger.line_item_id, is_take_order_product_related: true)
    end
  end

  def debit_stock_for_pickup!
    product_due_to_customers_account = event.accounts.where(name: 'Product due to Customers').first
    take_order_line_items.each do |line_item|
      new_stock_entry = Stock.create(unit_id: self.event.unit_id, product_id: line_item.product_id, location: 'take orders', quantity: -line_item.quantity, take_order_id: self.id, description: "Take order ##{line_item.take_order_id}", date: Date.today, created_by: 999, is_pickup: true)
    end
  end

  def credit_stock_for_reversed_pickup!
    stocks.pickups.destroy_all
  end

end
