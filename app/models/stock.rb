class Stock < ApplicationRecord
  belongs_to :product
  belongs_to :take_order
  belongs_to :direct_sale
  validates :product_id, :location, :quantity, presence: true

  attr_accessor :movement_with_warehouse

  LOCATIONS = [
    'warehouse',
    'site sale',
    'take orders',
    'distribution boxes'
    ]

  def self.site_sales
    where(location: 'site sale')
  end

  def self.take_orders
    where(location: 'take orders')
  end

  def self.wholesale_value(unit, event)
    value = 0
    unit.stocks.where(location: ['warehouse', 'site sale']).group(:product_id).sum(:quantity).each do |product_id,quantity|
      product = Product.find(product_id)
      value += product.retail_price * quantity
    end
    value = value * (1 - event.pack_commission_percentage / 100 )
    value
  end

  def self.is_transfer_from_bsa
    where(is_transfer_from_bsa: true)
  end

  def self.wholesale_value_due_to_bsa(unit)
    value = 0
    unit.stocks.is_transfer_from_bsa.each do |stock|
      value += stock.product.retail_price * stock.quantity
    end
    value * 0.65
  end
end