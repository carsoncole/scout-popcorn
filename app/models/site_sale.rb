class SiteSale < ApplicationRecord
  has_many :scout_site_sales
  has_many :site_sale_line_items
  belongs_to :event
  has_many :products, through: :site_sale_line_items
  has_many :site_sale_payment_methods

  validates :name, :date, presence: true

  after_save :debit_stock!, if: Proc.new { |to| to.status_changed? && to.status == 'closed'}
  after_save :do_ledgers!, if: Proc.new { |to| to.status_changed? && to.status == 'closed'}

  after_save :credit_stock!, if: Proc.new { |to| to.status_changed? && to.status == 'open'}
  after_save :reverse_ledgers!, if: Proc.new { |to| to.status_changed? && to.status == 'open'}


  STATUSES = { 
      open: { :status => :open, :name => 'Open', description: "Site sales figures not complete"},
      closed: { status: :closed, :name => 'Closed', description: "Sites sales figures complete" }
    }

  def self.open
    where(status: 'open')
  end

  def open?
    status == 'open'
  end

  def self.closed
    where(status: 'closed')
  end

  def closed?
    status == 'closed'
  end

  def payments_balance?
    site_sale_payment_methods.sum(:amount) == site_sale_line_items.sum(:value)
  end

  def full_name
    name + " (" + date.strftime('%a %b %e') + ')'
  end

  def scouts_that_worked
    scout_site_sales
  end

  def credited_sales(scout, event)
    if scout_site_sales.where(scout_id: scout.id).first
      hours_worked(scout) * event.total_site_sales_per_hour_worked
    end
  end

  def hours_worked(scout)
    scout_site_sales
  end

  def self.sales_by_scout_and_event(event)
    hash = {}
    event.site_sales.each do |site_sale|
      site_sale.scout_site_sales.each do |scout_site_sale|
        if hash[scout_site_sale.scout_id]
          hash[scout_site_sale.scout_id] += scout_site_sale.hours_worked * event.total_site_sales_per_hour_worked
        else
          hash[scout_site_sale.scout_id] = scout_site_sale.hours_worked * event.total_site_sales_per_hour_worked
        end
      end
    end
    hash
  end

  def total_sales
    site_sale_line_items.sum(:value)
  end

  def hours_worked(scout)
    if scout_site_sales.where(scout_id: scout.id).first
      scout_site_sales.where(scout_id: scout.id).first.hours_worked
    end
  end

  def total_hours_worked
    scout_site_sales.sum(:hours_worked)
  end

  private

  def debit_stock!
    site_sale_line_items.each do |line_item|
      event.unit.stocks.create(product_id: line_item.product_id, quantity: - line_item.quantity, location: 'site sale', date: self.date, site_sale_id: self.id)
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
