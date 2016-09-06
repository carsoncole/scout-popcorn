class Prize < ApplicationRecord
  belongs_to :event, optional: true
  validates :name, :amount, presence: true

  def self.default
    where(event_id: nil)
  end

  def self.pack
    where(source: 'pack')
  end

  def self.bsa
    where(source: 'bsa')
  end
end
