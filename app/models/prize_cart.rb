class PrizeCart < ApplicationRecord
  belongs_to :scout
  belongs_to :event
  has_many :cart_prizes, dependent: :destroy

  def self.approved
    where("is_approved_at IS NOT NULL")
  end

  def self.ordered
    where("is_ordered_at IS NOT NULL")
  end

  def self.ordered_and_not_approved
    ordered.where("is_approved_at IS NULL")
  end

  def self.open
    where(is_ordered_at: nil, is_approved_at: nil)
  end

  def ordered?
    !is_ordered_at.blank?
  end

  def approved?
    !is_approved_at.blank?
  end

  def self.ordered_or_approved
    where("is_approved_at IS NOT NULL OR is_ordered_at IS NOT NULL")
  end

  def orderable?
    cart_prizes.joins(:prize).where("prizes.source = 'bsa'").sum("prizes.amount") < scout.total_sales(event)
  end
end
