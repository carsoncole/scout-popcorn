class Stock < ApplicationRecord
  belongs_to :product
  validates :product_id, uniqueness: { scope: :unit_id }
  validates :location, presence: true

  LOCATIONS = [
    'Warehouse',
    'Site Sale',
    ]
end
