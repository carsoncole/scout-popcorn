class Event < ApplicationRecord
  belongs_to :unit
  has_many :purchase_orders, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :stocks, dependent: :destroy
  has_many :take_orders, through: :envelopes
  has_many :site_sales, dependent: :destroy
  has_many :take_order_line_items, through: :take_orders
  has_many :scout_site_sales, through: :site_sales
  has_many :take_order_purchase_orders
  has_many :purchase_orders, dependent: :destroy
  has_many :online_sales, dependent: :destroy
  has_many :envelopes, dependent: :destroy
  has_many :accounts, dependent: :destroy
  has_many :prize_carts, dependent: :destroy
  has_many :resources, dependent: :destroy
  has_many :prizes, dependent: :destroy

  validates :name, :unit_id, :unit_commission_percentage, :online_commission_percentage, :number_of_top_sellers, presence: true
  validates :number_of_top_sellers, numericality: { integer_only: true }
  validates :unit_commission_percentage, :online_commission_percentage, :number_of_top_sellers, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100, }

  scope :active, -> { where(is_active: true) }

  after_update :set_event_for_scouts!, if: Proc.new {|e| e.is_active_changed? && e.is_active }
  #after_create :create_default_products!
  #after_create :create_default_prizes!
  # before_destroy :disallow_destroy, prepend: true
  after_create :create_default_accounts!
  after_save :update_take_orders!, if: Proc.new {|e| e.unit_commission_percentage_changed? }
  after_save :reset_scouts_event!, if: Proc.new {|e| e.is_active == true }
  before_save :reset_is_active!, if: Proc.new {|e| e.is_active && ( e.is_active_changed? || e.new_record? )}
  after_update :reprocess_all!, if: Proc.new { |e| e.unit_commission_percentage_changed? }
  after_destroy :remove_event_from_scouts!

  def open_take_order_purchase_order
    open = take_order_purchase_orders.where(status: 'open').first
    unless open
      open = take_order_purchase_orders.create(event_id: self.id ? self.id : nil)
    end
    open
  end

  def total_site_sales(scout)
    total = 0
    site_sales.closed.each do |site_sale|
      total += site_sale.credited_sales(scout, @active_event) || 0
    end
    total
  end

  def total_site_sales
    site_sales.closed.joins(:site_sale_line_items).sum(:value)
  end

  def total_site_sale_donations
    site_sales.closed.joins(site_sale_line_items: :product).where("products.is_pack_donation = ?", true).sum(:value)
  end

  def important_dates?
    prize_cart_ordering_starts_at || 
      take_orders_deadline_at ? true : false

  end 

  def total_take_orders(is_turned_in: true)
    if is_turned_in
      envelopes.closed_or_picked_up.joins(take_orders: :take_order_line_items).sum('take_order_line_items.value')
    else
      envelopes.closed_or_picked_up.joins(take_orders: :take_order_line_items).sum('take_order_line_items.value')
    end
  end

  def total_take_order_donations
    envelopes.closed.joins(take_orders: [take_order_line_items: [:product]]).where("products.is_pack_donation = ?", true).sum(:value)
  end

  def bsa_wholesale_percentage
    1 - unit_commission_percentage / 100
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
    total_product_sales * (1 - unit_commission_percentage / 100)
  end

  def bank_account?
    accounts.is_bank_account_depositable.any?
  end

  def set_up?
    bank_account? && unit.treasurer? ? true : false 
  end

  def total_hours_worked
    site_sales.closed.joins(:scout_site_sales).sum(:hours_worked)
  end

  def total_site_sales_per_hour_worked
    hours = total_hours_worked
    if hours > 0
      total_site_sales / total_hours_worked
    else
      0
    end
  end

  def prizes?
    prizes.any?
  end

  def products?
    products.any?
  end

  def total_product_sales
    total_site_sales + total_take_orders - total_site_sale_donations - total_take_order_donations + total_online_sales
  end

  def total_sales
    total_site_sales + total_take_orders + total_online_sales
  end

  def create_default_prizes!
    Prize.default.each do |prize|
      self.prizes.where(name: prize.name).first_or_create(name: prize.name, amount: prize.amount, url: prize.url, source: prize.source, source_id: prize.source_id, is_by_level: prize.is_by_level, description: prize.description)
    end
  end

  def create_default_products!(sourced_from)
    Product.default(sourced_from).each do |product|
      self.products.where(name: product.name).first_or_create(name: product.name, retail_price: product.retail_price, url: product.url, sourced_from: product.sourced_from)
    end  
  end

  def has_default_products
    Product.default.each do |product|
      return true if products
    end
  end

  private

  def set_event_for_scouts!
    unit.scouts.update_all(event_id: self.id)
  end

  def create_default_accounts!
    Account.create_site_sales_cash!(self)
    Account.create_take_orders_cash!(self)
    Account.create_money_due_from_customers!(self)
    Account.create_product_due_to_customers!(self)
    Account.create_money_due_to_bsa!(self)
    Account.create_third_party_account!(self)
    Account.create_bank_accounts!(self)
    Account.create_inventory!(self)
  end

  def reset_scouts_event!
    unit.scouts.update_all(event_id: self.id)
  end

  # def disallow_destroy
  #   errors[:base] << "Only inactive events can be destroyed."
  #   throw :abort
  # end

  def update_take_orders!
    take_orders.each {|take_order| take_order.reprocess_money_received_and_product_due!}
  end

  def reprocess_all!
    stocks.each do |stock|
      next unless stock.ledger_id
      Ledger.find(stock.ledger_id).destroy
      stock.create_due_to_bsa!
    end
  end

  def reset_is_active!
    unit.events.active.update_all(is_active: false)
  end

  def remove_event_from_scouts!
    unit.scouts.where(event_id: self.id).update_all(event_id: nil)
  end

end