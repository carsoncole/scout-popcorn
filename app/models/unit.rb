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

  after_create :create_default_payment_methods!

  def default_event
    events.last
  end

  private

  def create_default_payment_methods!
    payment_methods.create(name: 'Cash', is_cash: true)
    payment_methods.create(name: 'Check')
  end
end
