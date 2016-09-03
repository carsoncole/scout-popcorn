class Stock < ApplicationRecord
  belongs_to :product
  validates :product_id, :location, :created_by, presence: true

  LOCATIONS = [
    'warehouse',
    'site sale',
    'distribution boxes'
    ]
end