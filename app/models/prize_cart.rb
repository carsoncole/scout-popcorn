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

  def self.open
    where(is_ordered_at: nil, is_approved_at: nil)
  end

  def ordered?
    !is_ordered_at.blank?
  end

  def approved?
    !is_approved_at.blank?
  end
end
