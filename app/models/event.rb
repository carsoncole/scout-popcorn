class Event < ApplicationRecord
  belongs_to :unit
  has_many :purchase_orders
  has_many :prizes
  has_many :products
  has_many :take_orders, dependent: :destroy
  has_many :site_sales, dependent: :destroy
  has_many :line_items, through: :take_orders
  has_many :scout_site_sales, through: :site_sales
  has_many :take_order_purchase_orders
  has_many :purchase_orders, dependent: :destroy
  has_many :online_sales, dependent: :destroy
  has_many :envelopes
  has_many :accounts
  has_many :prize_carts

  validates :name, :pack_commission_percentage, :number_of_top_sellers, presence: true

  after_create :create_default_products!
  after_create :create_default_prizes!
  after_create :create_default_accounts!
  after_save :update_take_orders!, if: Proc.new {|e| e.pack_commission_percentage_changed? }

  def self.active
    where(is_active: true)
  end

  def open_take_order_purchase_order
    open = take_order_purchase_orders.where(status: 'open').first
    unless open
      open = take_order_purchase_orders.create(event_id: self.id ? self.id : nil)
    end
    open
  end

  def total_site_sales(scout)
    total = 0
    site_sales.each do |site_sale|
      total += site_sale.credited_sales(scout, @active_event) || 0
    end
    total
  end

  def total_site_sales
    site_sales.joins(:site_sale_line_items).sum(:value)
  end

  def total_site_sale_donations
    site_sales.joins(site_sale_line_items: :product).where("products.is_pack_donation = ?", true).sum(:value)
  end

  def total_take_orders(is_turned_in: true)
    if is_turned_in
      envelopes.closed.joins(take_orders: :take_order_line_items).sum('take_order_line_items.value')
    else
      envelopes.closed.joins(take_orders: :take_order_line_items).sum('take_order_line_items.value')
    end
  end

  def total_take_order_donations
    envelopes.joins(take_orders: [take_order_line_items: [:product]]).where("products.is_pack_donation = ?", true).sum(:value)
  end

  def bsa_wholesale_percentage
    1 - pack_commission_percentage / 100
  end
  
  def allow_prize_cart_ordering?
    prize_cart_ordering_starts_at.blank? || prize_cart_ordering_starts_at < Time.now
  end

  def take_orders_allowed?
    take_orders_deadline_at.blank? || take_orders_deadline_at > Time.now
  end

  def total_online_sales
    online_sales.sum(:amount)
  end

  def cost_of_goods_sold
    total_product_sales * (1 - pack_commission_percentage / 100)
  end

  def bank_account?
    accounts.is_bank_account_depositable.any?
  end

  def set_up?
    bank_account? && unit.treasurer? ? true : false 
  end

  def total_hours_worked
    site_sales.joins(:scout_site_sales).sum(:hours_worked)
  end

  def total_site_sales_per_hour_worked
    hours = total_hours_worked
    if hours > 0
      total_site_sales / total_hours_worked
    else
      0
    end
  end

  def total_product_sales
    total_site_sales + total_take_orders - total_site_sale_donations - total_take_order_donations + total_online_sales
  end

  def total_sales
    total_site_sales + total_take_orders + total_online_sales
  end

  private

  def create_default_products!
    Product.default.each do |product|
      self.products.where(name: product.name).first_or_create(name: product.name, quantity: product.quantity, retail_price: product.retail_price, url: product.url)
    end  
  end

  def create_default_prizes!
    Prize.default.each do |prize|
      self.prizes.where(name: prize.name).first_or_create(name: prize.name, amount: prize.amount, url: prize.url, source: prize.source, source_id: prize.source_id, is_by_level: prize.is_by_level, description: prize.description)
    end   
  end

  def create_default_accounts!
    Account.create_site_sales_cash!(self)
    Account.create_take_orders_cash!(self)
    Account.create_money_due_from_customers!(self)
    Account.create_product_due_to_customers!(self)
    Account.create_money_due_to_bsa!(self)
    Account.create_bsa_credit_card!(self)
  end

  def update_take_orders!
    take_orders.each {|take_order| take_order.reprocess_money_received_and_product_due!}
  end
end