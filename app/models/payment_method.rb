class PaymentMethod < ApplicationRecord
  belongs_to :unit
  has_many :take_orders
  validates :name, presence: true
end
