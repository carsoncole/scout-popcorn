class PrizeCart < ApplicationRecord
  belongs_to :scout
  belongs_to :event
  has_many :cart_prizes, dependent: :destroy
  has_many :prizes, through: :cart_prizes

  validates :scout_id, :event_id, presence: true

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

  def sales_credits_used(source)
    cart_prizes.joins(:prize).where("prizes.reduces_sales_credits = ?",true).where("prizes.source = ?", source).sum('prizes.sales_amount * quantity')
  end

  def available_sales_credits(source)
    scout.sales(event) - sales_credits_used(source)
  end

  def ordered?
    !is_ordered_at.blank?
  end

  def approved?
    !is_approved_at.blank?
  end

  def product_ids
    cart_prizes.map {|cp| cp.id }
  end

  def self.ordered_or_approved
    where("is_approved_at IS NOT NULL OR is_ordered_at IS NOT NULL")
  end

  def orderable?
    cart_prizes.joins(:prize).where("prizes.source = 'bsa'").sum("prizes.amount") < scout.total_sales(event)
  end

  def process_automatic_prizes!
    eligible_prizes = event.prizes.does_not_reduce_sales_credits.where("sales_amount < ?", scout.sales(event))
    eligible_prizes.each do |prize|
      cart_prizes.create(prize: prize, quantity: 1) unless cart_prizes.where(prize: prize).any?
    end
  end


end
