class SiteSaleLineItem < ApplicationRecord
  belongs_to :site_sale
  belongs_to :product
  validates :product_id, :quantity, presence: true
  before_save :update_value!
  validate :check_for_available_stock

  private


  def check_for_available_stock
    if self.product.is_physical_inventory
      if self.quantity > site_sale.event.unit.stocks.site_sales.where(product_id: self.product_id).sum(:quantity) 
          self.errors.add(:base,"There is insufficient inventory to cover the #{self.product.name} quantity sold.")
      end
    end
  end

  def update_value!
    self.value = quantity * product.retail_price
  end

end
