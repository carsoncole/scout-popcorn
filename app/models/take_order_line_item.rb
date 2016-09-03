class TakeOrderLineItem < ApplicationRecord
  belongs_to :take_order
  belongs_to :product
  validates :product_id, :quantity, presence: true
  before_save :update_value!

  private

  def update_value!
    self.value = quantity * product.retail_price
  end

end
