class Product < ApplicationRecord
  belongs_to :event, optional: true
  has_many :take_order_line_items
  has_many :site_sale_line_items
  has_many :take_orders, through: :take_order_line_items
  has_many :site_sales, through: :site_sale_line_items
  has_many :stocks

  validates :name, :retail_price, presence: true
  validates :retail_price, inclusion: { in: [1], message: "should be set to $1 since this is a Unit donation."}, if: Proc.new {|p| p.is_pack_donation }
  validates :is_sourced_from_bsa, inclusion: { in: [false], message: "should not be selected since this is a Unit donation"}, if: Proc.new { |p| p.is_sourced_from_bsa && p.is_pack_donation }
  validates :is_physical_inventory, inclusion: { in: [false], message: "should not be selected since this is a Unit donation"}, if: Proc.new { |p| p.is_physical_inventory && p.is_pack_donation }
  validates :url, format: {with: /\.(png|jpg)\Z/i}, if: Proc.new {|p| p.url.present? }

  before_destroy :disallow_if_used!
  before_update :disallow_if_used!, if: Proc.new { |p| p.retail_price_changed? }

  scope :active, -> { where(is_active: true )}

  def self.default
    where(event_id: nil)
  end

  def name_with_id
    name + " (" + id.to_s + ")" 
  end

  def self.physical
    where(is_physical_inventory: true)
  end

  def physical?
    is_physical_inventory == true
  end

  def self.is_sourced_from_bsa
    where(is_sourced_from_bsa: true)
  end

  def self.take_order_left(take_order)
    Product.where(event_id: take_order.event_id).order(:name).reject{ |p| take_order.products.include? p}
  end

  def self.site_sale_left(site_sale)
    Product.where(event_id: site_sale.event_id).order(:name).reject{ |p| site_sale.products.include? p}
  end

  def used?
    stocks.any? || site_sale_line_items.any? || take_order_line_items.any?
  end

  def disallow_if_used!
    if used?
      errors.add(:base, "Product can not be modified/destroyed since it has been used." )
    end

  end

end
