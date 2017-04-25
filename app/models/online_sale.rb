class OnlineSale < ApplicationRecord
  belongs_to :scout
  belongs_to :event

  validates :scout_id, :event_id, :amount, :customer_name, presence: true
  validates :amount, numericality: true
end