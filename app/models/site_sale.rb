class SiteSale < ApplicationRecord
  has_many :scout_site_sales
  has_many :site_sale_line_items
  belongs_to :event
  has_many :products, through: :site_sale_line_items

  validates :name, :date, presence: true

  after_save :debit_stock!, if: Proc.new { |to| to.status_changed? && to.status == 'closed'}

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

  def full_name
    name + " (" + date.strftime('%a %b %e') + ')'
  end

  def scouts_that_worked
    scout_site_sales
  end

  def credited_sales(scout)
    if scout_site_sales.where(scout_id: scout.id).first
      hours_worked(scout) * sales_per_hour_worked
    end
  end

  def self.sales_by_scout_and_event(event)
    hash = {}
    event.site_sales.each do |site_sale|
      site_sale.scout_site_sales.each do |scout_site_sale|
        if hash[scout_site_sale.scout_id]
          hash[scout_site_sale.scout_id] += site_sale.credited_sales(scout_site_sale.scout)
        else
          hash[scout_site_sale.scout_id] = site_sale.credited_sales(scout_site_sale.scout)
        end
      end
    end
    hash
  end

  def hours_worked(scout)
    if scout_site_sales.where(scout_id: scout.id).first
      scout_site_sales.where(scout_id: scout.id).first.hours_worked
    end
  end

  def sales_per_hour_worked
    site_sale_line_items.sum(:value) / total_hours_worked
  end

  def total_hours_worked
    scout_site_sales.sum(:hours_worked)
  end

  private

  def debit_stock!
    site_sale_line_items.each do |line_item|
      # available_stock = event.unit.stocks.where(product_id: line_item.product_id, location: 'site sales').first
      # if available_stock
      #   available_stock.update(quantity: available_stock.quantity - line_item.quantity, location: 'site sales')
      # else
      event.unit.stocks.create(product_id: line_item.product_id, quantity: - line_item.quantity, location: 'site sales')
      # end
    end
  end
end
