class Unit < ApplicationRecord
  has_many :scouts, dependent: :destroy
  has_many :stocks, dependent: :destroy
  has_many :prizes, through: :events
  has_many :payment_methods
  has_many :events, dependent: :destroy
  has_many :take_orders, through: :scouts
  has_many :site_sales, through: :scouts
  has_many :purchase_orders, through: :events
  has_many :take_order_purchase_orders
  has_many :accounts, through: :events
  has_many :ledgers, through: :accounts

  validates :treasurer_email, format: /@/, unless: Proc.new {|u| u.treasurer_email.blank? }
  validates :treasurer_first_name, presence: true, unless: Proc.new {|u| u.treasurer_email.blank? }

  after_create :create_default_payment_methods!

  def default_event
    events.last
  end

  def treasurer_name
    (treasurer_first_name || '') + ' ' + (treasurer_last_name || '')
  end

  def inventory(product)
    stocks.where.not(location: 'take orders').where(product_id: product.id).sum(:quantity)
  end

  private

  def create_default_payment_methods!
    payment_methods.create(name: 'Cash', is_cash: true)
    payment_methods.create(name: 'Check')
  end
end