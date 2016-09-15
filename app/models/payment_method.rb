class PaymentMethod < ApplicationRecord
  belongs_to :unit
  has_many :take_orders
  validates :name, presence: true

  def self.cash
    where(is_cash: true)
  end

  def self.square
    where(name: 'Square')
  end

  def self.bsa_credit_card
    where(name: 'BSA Credit Card')
  end
end
