class CartPrize < ApplicationRecord
  belongs_to :prize 
  belongs_to :prize_cart

  validates :prize_id, :prize_amount, :prize_cart_id, presence: true
  validate :check_value_of_prizes

  def self.approved
    where("is_approved_at IS NOT NULL")
  end

  def self.complete
    where("is_complete_at IS NOT NULL")
  end

  def complete?
    !is_complete_at.blank?
  end

  def approved?
    !is_approved_at.blank?
  end

  protected
  def check_value_of_prizes
    if prize_cart.cart_prizes.joins(:prize).where("prizes.source = 'bsa'").sum(:prize_amount) > prize_cart.scout.total_sales(self.prize_cart.event)
      errors[:base] << "Your cart is full"
    end
    nil
  end
end
