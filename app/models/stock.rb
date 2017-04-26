class Stock < ApplicationRecord
  belongs_to :product
  belongs_to :take_order, optional: true
  belongs_to :site_sale, optional: true
  belongs_to :event

  LOCATIONS = [
    'warehouse',
    'site sales',
    'take orders'
    ]

  validates :product_id, :location, :quantity, :date, presence: true
  validates :location, inclusion: { in: Stock::LOCATIONS }

  attr_accessor :movement_with_warehouse

  after_create :create_due_to_bsa!, if: Proc.new { |s| s.is_transfer_from_bsa }

  def self.warehouse
    where(location: 'warehouse')
  end

  def self.site_sales
    where(location: 'site sales')
  end

  def self.take_orders
    where(location: 'take orders')
  end

  def self.pickups
    where(is_pickup: true)
  end

  def self.wholesale_value(event)
    value = 0
    event.stocks.joins(:product).where("products.is_physical_inventory = ?",true).where("products.is_pack_donation = ? OR products.is_pack_donation IS NULL", false).group(:product_id).sum(:quantity).each do |product_id,quantity|
      product = Product.find(product_id)
      value += product.retail_price * quantity
    end
    value = value * (1 - event.unit_commission_percentage / 100 )
    value
  end

  def self.is_transfer_from_bsa
    where(is_transfer_from_bsa: true)
  end 

  def create_due_to_bsa!
    account = event.accounts.where(is_due_to_bsa: true).first
    wholesale_amount = quantity * product.retail_price * (1 - (event.unit_commission_percentage / 100))
    account.ledgers.create(description: 'BSA inventory transfer', amount: wholesale_amount, date: date)
  end
end