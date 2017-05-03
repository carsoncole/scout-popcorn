class Stock < ApplicationRecord
  belongs_to :product
  belongs_to :take_order, optional: true
  belongs_to :site_sale, optional: true
  belongs_to :event
  has_one :ledger, dependent: :destroy


  LOCATIONS = [
    'warehouse',
    'site sales',
    'take orders'
    ]

  validates :product_id, :location, :quantity, :date, presence: true
  validates :location, inclusion: { in: Stock::LOCATIONS }

  attr_accessor :movement_with_warehouse


  before_save :update_wholesale_value!, if: Proc.new { |s| s.quantity_changed? || s.product_id_changed? }
  before_create :debit_warehouse!, if: Proc.new { |s| s.is_transfer_from_warehouse }
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
    #TODO This may need refactoring to utilize wholesale_value attribute

    value = 0
    event.stocks.joins(:product).where("products.is_physical_inventory = ?",true).where("products.is_pack_donation = ? OR products.is_pack_donation IS NULL", false).group(:product_id).sum(:quantity).each do |product_id,quantity|
      product = Product.find(product_id)
      value += product.retail_price * quantity
    end
    value = value * (1 - event.unit_commission_percentage / 100 )
    value
  end

  def debit_warehouse!
    event.stocks.create(quantity: -quantity, location: 'warehouse', created_by: created_by, product_id: product_id, event_id: event_id, date: date)
  end

  def self.is_transfer_from_bsa
    where(is_transfer_from_bsa: true)
  end 

  def update_wholesale_value!
    self.wholesale_value = quantity * product.retail_price * (1 - event.unit_commission_percentage / 100.00)
  end

  def create_due_to_bsa!
    account = event.accounts.where(is_due_to_bsa: true).first
    ledger = account.ledgers.create(description: 'BSA inventory transfer', amount: wholesale_value, date: date, stock_id: id)
    self.update(ledger_id: ledger.id)
  end
end