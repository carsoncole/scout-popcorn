class SiteSale < ApplicationRecord
  has_many :scout_site_sales, dependent: :destroy
  has_many :site_sale_line_items, dependent: :destroy
  belongs_to :event
  has_many :products, through: :site_sale_line_items
  has_many :site_sale_payment_methods, dependent: :destroy

  scope :closed, -> { where('closed_at NOT NULL') }
  scope :open, -> { where(closed_at: nil) }

  validates :name, :date, :event_id, presence: true

  #TODO add before_save callback to check that payment methods have been added.

  after_save :debit_stock!, if: Proc.new { |to| to.closed_at_changed? && to.closed?}
  after_save :do_ledgers!, if: Proc.new { |to| to.closed_at_changed? && to.closed? }

  after_save :credit_stock!, if: Proc.new { |to| to.closed_at_changed? && to.open? }
  after_save :reverse_ledgers!, if: Proc.new { |to| to.closed_at_changed? && to.open? }

  def open?
    closed_at.nil?
  end

  def closed?
    closed_at.present?
  end

  def payments_balance?
    site_sale_payment_methods.sum(:amount) == site_sale_line_items.sum(:value)
  end

  def full_name
    name + " (" + date.strftime('%a %b %e') + ')'
  end

  def hours_worked(scout=nil)
    if scout
      scout_site_sales.where(scout_id: scout.id).sum(:hours_worked)
    else
      scout_site_sales.sum(:hours_worked)
    end
  end

  def sales(scout=nil)
    if scout
      hours_worked(scout) * event.total_site_sales_per_hour_worked(false)
    else
      site_sale_line_items.sum(:value)
    end
  end

  private

  def debit_stock!
    site_sale_line_items.each do |line_item|
      event.stocks.create(product_id: line_item.product_id, quantity: - line_item.quantity, location: 'site sales', date: self.date, site_sale_id: self.id)
    end
  end

  def credit_stock!
    Stock.where(site_sale_id: self.id).destroy_all
  end

  def do_ledgers!
    site_sale_payment_methods.each do |payment_method|
      Ledger.transaction do
        Ledger.create(account_id: payment_method.account_id, amount: payment_method.amount, date: self.date, site_sale_id: self.id)
      end
    end
  end

  def reverse_ledgers!
    Ledger.where(site_sale_id: self.id).destroy_all
  end
end
