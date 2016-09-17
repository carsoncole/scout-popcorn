class Product < ApplicationRecord
  belongs_to :event, optional: true
  has_many :take_order_line_items
  has_many :site_sale_line_items
  has_many :take_orders, through: :take_order_line_items
  has_many :site_sales, through: :take_order_line_items

  validates :name, :retail_price, :quantity, presence: true

  WHOLESALE_COST_PERCENTAGE = 0.65


  def self.default
    where(event_id: nil)
  end

  def name_with_id
    name + " (" + id.to_s + ")" 
  end


  def self.take_order_left(take_order)
    Product.where(event_id: take_order.event_id).order(:name).reject{ |p| take_order.products.include? p}
  end

  def self.site_sale_left(site_sale)
    Product.where(event_id: site_sale.event_id).order(:name).reject{ |p| site_sale.products.include? p}
  end

end
