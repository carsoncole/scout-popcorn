class Prize < ApplicationRecord
  SOURCES = [ 'Unit', 'Council' ]

  belongs_to :event, optional: true
  has_many :cart_prizes
  has_many :prize_carts, through: :cart_prizes
  validates :name, :sales_amount, :source, presence: true
  validates :name, length: { maximum: 40 }
  validates :name, uniqueness: { scope: :event }

  validates :sales_amount, numericality: true
  validates :source, inclusion: { in: Prize::SOURCES }

  before_destroy :check_if_used

  def check_if_used
    if cart_prizes.any?
      errors[:base] << 'Can not be destroyed since Prize is in use'
      throw :abort
    end
  end
  # def self.default
  #   where(event_id: nil)
  # end

  # def self.pack
  #   where(source: 'pack')
  # end

  # def self.bsa
  #   where(source: 'bsa')
  # end

  # def self.bsa_bonus
  #   where(source: 'bsa-bonus')
  # end

  # def self.process_bonus_prizes!(event, s=nil)
  #   scouts = []
  #   if s
  #     scouts << s
  #   else
  #     scouts += event.unit.scouts
  #   end
  #   scouts.each do |scout|
  #     scout.prize_cart(event).cart_prizes.joins(:prize).where("prizes.source = ?", 'bsa-bonus').destroy_all
  #     total_sales = scout.total_sales(event)
  #     bsa_bonus_prizes = event.prizes.bsa_bonus.where("sales_amount <= ?", total_sales)
  #     bsa_bonus_prizes.each do |prize|
  #       scout.prize_cart(event).cart_prizes.create(prize_id: prize.id, prize_amount: prize.sales_amount)
  #     end
  #   end
  # end

end
