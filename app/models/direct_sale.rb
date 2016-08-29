class DirectSale < ApplicationRecord
  belongs_to :scout
  belongs_to :event
  belongs_to :product

  validates :product_id, :quantity, :event_id, :scout_id, presence: true

  before_save :calculate_amount!

  private

  def calculate_amount!
    self.amount = quantity * price
  end
end
