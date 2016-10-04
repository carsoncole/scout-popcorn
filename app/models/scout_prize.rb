class ScoutPrize < ApplicationRecord
  belongs_to :prize 
  belongs_to :scout 
  belongs_to :event

  validates :scout_id, :prize_id, :event_id, :prize_amount, presence: true

  validate :check_value_of_prizes

  protected
  def check_value_of_prizes
    if scout.scout_prizes.sum(:prize_amount) > scout.total_sales(self.event)
      errors[:base] << "Your cart is full"
    end
    nil
  end
end
