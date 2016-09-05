class OnlineSale < ApplicationRecord
  belongs_to :scout
  belongs_to :event

  validates :scout_id, :event_id, presence: true
end
