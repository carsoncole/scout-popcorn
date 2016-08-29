class Prize < ApplicationRecord
  belongs_to :event, optional: true
  validates :name, :amount, presence: true

  def self.default
    where(event_id: nil)
  end
end
