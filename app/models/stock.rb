class Stock < ApplicationRecord
  belongs_to :product
  validates :product_id, uniqueness: { scope: :unit_id }
end
