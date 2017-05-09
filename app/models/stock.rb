class Stock < ApplicationRecord
  include ApplicationHelper

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

  def self.wholesale_value(event, product=nil, location=nil)
    value = 0
    if product && location
      event.stocks.joins(:product).where("products.is_physical_inventory = ? AND 
        products.id = ? AND location = ? AND ( products.is_pack_donation = ? OR products.is_pack_donation IS NULL)", true, product.id, location, false).group(:product_id).sum(:wholesale_value).each do | product_id, wholesale_value |
        value += wholesale_value
      end
    elsif product
      event.stocks.joins(:product).where("products.is_physical_inventory = ? AND 
        products.id = ? AND ( products.is_pack_donation = ? OR products.is_pack_donation IS NULL)", true,product.id, false).group(:product_id).sum(:wholesale_value).each do | product_id, wholesale_value |
        value += wholesale_value
      end
    elsif location
      event.stocks.joins(:product).where("products.is_physical_inventory = ? AND location = ? AND ( products.is_pack_donation = ? OR products.is_pack_donation IS NULL)", true,location, false).group(:product_id).sum(:wholesale_value).each do | product_id, wholesale_value |
        value += wholesale_value
      end
    else
      event.stocks.joins(:product).where("products.is_physical_inventory = ? AND ( products.is_pack_donation = ? OR products.is_pack_donation IS NULL)", true, false).group(:product_id).sum(:wholesale_value).each do | product_id, wholesale_value |
        value += wholesale_value
      end      
    end
    value
  end

  def balance(location=nil)
    if location
      Stock.where(product_id: self.product_id, location: location).sum(:quantity)
    else
      Stock.where(product_id: self.product_id).sum(:quantity)
    end
  end

  def debit_warehouse!
    event.stocks.create(quantity: -quantity, location: 'warehouse', created_by: created_by, product_id: product_id, event_id: event_id, date: date)
  end

  def self.is_transfer_from_bsa
    where(is_transfer_from_bsa: true)
  end 

  def update_wholesale_value!
    self.wholesale_value = calculate_wholesale_value(product, quantity)
  end

  def create_due_to_bsa!
    account = Account.due_to_bsa(event)
    ledger = account.ledgers.create(description: 'BSA inventory transfer', amount: wholesale_value, date: date, stock_id: id)
    self.update(ledger_id: ledger.id)
  end
end