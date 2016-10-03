class Event < ApplicationRecord
  belongs_to :unit
  has_many :purchase_orders
  has_many :prizes
  has_many :products
  has_many :scout_prizes
  has_many :direct_sales, dependent: :destroy
  has_many :take_orders, dependent: :destroy
  has_many :site_sales, dependent: :destroy
  has_many :line_items, through: :take_orders
  has_many :scout_site_sales, through: :site_sales
  has_many :take_order_purchase_orders
  has_many :purchase_orders, dependent: :destroy
  has_many :online_sales, dependent: :destroy
  has_many :envelopes

  validates :name, :pack_commission_percentage, presence: true

  after_create :add_default_products!
  after_create :add_default_prizes!

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

  def top_take_order_sellers
    take_orders.includes(:scouts).group
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

  def total_take_orders
    envelopes.joins(take_orders: :take_order_line_items).sum('take_order_line_items.value')
  end

  def total_take_order_donations
    envelopes.joins(take_orders: [take_order_line_items: [:product]]).where("products.is_pack_donation = ?", true).sum(:value)
  end

  def total_online_sales
    0
  end

  def cost_of_goods_sold
    total_product_sales * (1 - pack_commission_percentage / 100)
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
    total_site_sales + total_take_orders - total_site_sale_donations - total_take_order_donations
  end

  def total_sales
    total_site_sales + total_take_orders
  end

  private

  def add_default_products!
    Product.default.each do |product|
      self.products.where(name: product.name).first_or_create(name: product.name, quantity: product.quantity, retail_price: product.retail_price, url: product.url)
    end  
  end

  def add_default_prizes!
    Prize.default.each do |prize|
      self.prizes.where(name: prize.name).first_or_create(name: prize.name, amount: prize.amount, url: prize.url, source: prize.source, source_id: prize.source_id, is_by_level: prize.is_by_level, description: prize.description)
    end   
  end

end
