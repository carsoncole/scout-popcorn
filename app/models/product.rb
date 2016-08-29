class Product < ApplicationRecord
  belongs_to :event, optional: true
  has_many :line_items
  has_many :take_orders, through: :line_items

  validates :name, :retail_price, :quantity, presence: true

  def self.default
    where(event_id: nil)
  end

  def self.left(take_order)
    Product.all.reject{ |p| take_order.products.include? p}
  end
end
