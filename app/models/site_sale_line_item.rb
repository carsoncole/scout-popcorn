class SiteSaleLineItem < ApplicationRecord
  belongs_to :site_sale
  belongs_to :product
  validates :product_id, :quantity, presence: true
  before_save :update_value!

  private

  def update_value!
    self.value = quantity * product.retail_price
  end

end
