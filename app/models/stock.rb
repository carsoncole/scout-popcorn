class Stock < ApplicationRecord
  belongs_to :product
  belongs_to :take_order, optional: true
  belongs_to :site_sale, optional: true
  validates :product_id, :location, :quantity, :date, presence: true

  attr_accessor :movement_with_warehouse

  LOCATIONS = [
    'warehouse',
    'site sales',
    'take orders'
    ]

  def self.warehouse
    where(location: 'site sale')
  end

  def self.site_sales
    where(location: 'site sale')
  end

  def self.take_orders
    where(location: 'take orders')
  end

  def self.pickups
    where(is_pickup: true)
  end

  def self.wholesale_value(unit, event)
    value = 0
    event.stocks.joins(:product).where("products.is_physical_inventory = ?",true).where("products.is_pack_donation = ? OR products.is_pack_donation IS NULL", false).group(:product_id).sum(:quantity).each do |product_id,quantity|
      product = Product.find(product_id)
      value += product.retail_price * quantity
    end
    value = value * (1 - event.pack_commission_percentage / 100 )
    value
  end

  def self.is_transfer_from_bsa
    where(is_transfer_from_bsa: true)
  end 
end