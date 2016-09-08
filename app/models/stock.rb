class Stock < ApplicationRecord
  belongs_to :product
  validates :product_id, :location, presence: true

  LOCATIONS = [
    'warehouse',
    'site sale',
    'distribution boxes'
    ]

  def self.site_sales
    where(location: 'site sales')
  end
end