class PrizeCart < ApplicationRecord
  belongs_to :scout
  belongs_to :event
  has_many :cart_prizes, dependent: :destroy
  has_many :prizes, through: :cart_prizes

  validates :scout_id, :event_id, presence: true

  after_save :add_prize_costs_to_expenses!, if: Proc.new {|pc| pc.saved_change_to_is_approved_at? && pc.approved? }

  after_save :remove_prize_costs_from_expenses!, if: Proc.new {|pc| pc.saved_change_to_is_approved_at? && !pc.approved? }

  # after_save :deduct_from_sales_credits!, if: Proc.new {|pc| pc.saved_change_to_is_ordered_at? && pc.is_ordered_at }

  # after_save :credit_sales_credits!, if: Proc.new {|pc| pc.saved_change_to_is_ordered_at? && pc.is_ordered_at.nil? }

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

  def self.total_unit_cost(event)
    approved.where(event_id: event.id).joins(cart_prizes: :prize).where("prizes.source = ?", 'Unit').sum('prizes.cost * cart_prizes.quantity')
  end

  def sales_credits_used(source)
    cart_prizes.joins(:prize).where("prizes.reduces_sales_credits = ?",true).where("prizes.source = ?", source).sum('prizes.sales_amount * quantity')
  end

  def sales_credits_available(source)
    # scout.sales(event) - sales_credits_used(source)
    scout.sales_credit_balance(event) - sales_credits_used(source)
  end

  def ordered?
    !is_ordered_at.blank?
  end

  def approved?
    !is_approved_at.blank?
  end

  def status
    if approved?
      "Approved"
    elsif ordered?
      "Ordered"
    else
      "In Process"
    end
  end

  def product_ids
    cart_prizes.map {|cp| cp.id }
  end

  def self.ordered_or_approved
    where("is_approved_at IS NOT NULL OR is_ordered_at IS NOT NULL")
  end

  def orderable?
    sales = scout.sales(event)
    result = true
    Prize::SOURCES.each do |source|
      if sales > sales_credits_used(source)
        result = false
      end
    end
  end

  def deduct_from_sales_credits!
    credits = 0
    cart_prizes.each do |cp|
      if cp.prize.reduces_sales_credits
        credits += cp.prize.sales_amount * cp.quantity
      end
    end
    scout.sales_credits.create(event_id: self.event_id, amount: -credits, description: 'Used for prizes')
  end

  def credit_sales_credits!
    credits = 0
    cart_prizes.each do |cp|
      if cp.prize.reduces_sales_credits
        credits += cp.prize.sales_amount * cp.quantity if cp.prize.reduces_sales_credits
      end
    end
    scout.sales_credits.create(event_id: self.event_id, amount: credits, description: 'Reopend. Credited back sales credits used for prizes')     
  end

  def process_automatic_prizes!
    cart_prizes.where(is_automatic: true).destroy_all
    sales_credits = scout.sales_credit_totals.where(event_id: event.id)
    sales_credits = sales_credits.any? ? sales_credits.first.amount : 0
    eligible_prizes = event.prizes.does_not_reduce_sales_credits.where("sales_amount < ?", sales_credits)
    eligible_prizes.each do |prize|
      cart_prizes.create(prize: prize, quantity: 1, is_automatic: true) unless cart_prizes.where(prize: prize).any?
    end
  end

  def add_prize_costs_to_expenses!
    expense = cart_prizes.joins(:prize).sum("prizes.cost * cart_prizes.quantity")
    popcorn_expense_account = event.accounts.where(name: 'Unit prizes').last
    Ledger.create(account_id: popcorn_expense_account.id, amount: expense, prize_cart_id: self.id, description: "Prizes expensed for #{self.scout.name}", date: Date.today)
  end

  def remove_prize_costs_from_expenses!
    Ledger.joins(:account).where("accounts.name = ? AND prize_cart_id = ?", 'Unit prizes', self.id).destroy_all
  end

end
