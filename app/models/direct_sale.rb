class DirectSale < ApplicationRecord
  belongs_to :scout
  belongs_to :event
  belongs_to :product

  validates :product_id, :quantity, :event_id, :scout_id, presence: true

  before_save :calculate_amount!
  after_save :debit_stock!

  def self.sales_by_scout_and_event(event)
    event.direct_sales.group(:scout_id).sum(:amount)
  end

  private

  def calculate_amount!
    self.amount = quantity * price
  end

  def debit_stock!
    available_stock = scout.unit.stocks.where(product_id: product_id).first
    if available_stock
      available_stock.update(quantity: available_stock.quantity - quantity)
    else
      scout.unit.stocks.create(product_id: product.id, quantity: -quantity)
    end
  end
end
