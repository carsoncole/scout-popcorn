class Stock < ApplicationRecord
  belongs_to :product
  belongs_to :take_order
  belongs_to :direct_sale
  validates :product_id, :location, presence: true

  attr_accessor :movement_with_warehouse

  LOCATIONS = [
    'warehouse',
    'site sale',
    'distribution boxes'
    ]

  def self.site_sales
    where(location: 'site sales')
  end
end