class Stock < ApplicationRecord
  belongs_to :product
  validates :product_id, :location, presence: true

  LOCATIONS = [
    'warehouse',
    'site sale',
    'distribution boxes'
    ]
end