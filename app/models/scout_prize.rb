class ScoutPrize < ApplicationRecord
  belongs_to :prize 
  belongs_to :scout 
  belongs_to :event

  validates :scout_id, :prize_id, :event_id, :prize_amount, presence: true
end
