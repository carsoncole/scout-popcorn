class Prize < ApplicationRecord
  SOURCES = [ 'Unit', 'Council' ]

  belongs_to :event, optional: true
  has_many :cart_prizes
  has_many :prize_carts, through: :cart_prizes
  validates :name, :sales_amount, :source, presence: true
  validates :name, length: { maximum: 40 }
  validates :name, uniqueness: { scope: :event }

  scope :does_not_reduce_sales_credits, -> { where(reduces_sales_credits: false)}

  validates :sales_amount, numericality: true
  validates :source, inclusion: { in: Prize::SOURCES }

  before_destroy :check_if_used

  def check_if_used
    if cart_prizes.any?
      errors[:base] << 'Can not be destroyed since Prize is in use'
      throw :abort
    end
  end

end
