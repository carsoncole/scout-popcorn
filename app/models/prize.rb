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

  def self.bsa_bonus
    where(source: 'bsa-bonus')
  end

  def self.process_bonus_prizes!(scout, event)
    scout.scout_prizes.joins(:prize).where("prizes.source = ?", 'bsa-bonus').destroy_all
    total_sales = scout.total_sales(event)
    bsa_bonus_prizes = event.prizes.bsa_bonus.where("amount <= ?", total_sales)
    bsa_bonus_prizes.each do |prize|
      scout.scout_prizes.create(event_id: event.id, prize_id: prize.id, prize_amount: prize.amount)
    end
  end

end
