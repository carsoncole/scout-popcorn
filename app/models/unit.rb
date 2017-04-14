class Unit < ApplicationRecord
  has_many :scouts, dependent: :destroy
  has_many :payment_methods
  has_many :events, dependent: :destroy
  has_many :ledgers, through: :accounts

  validates :name, presence: true
  validates :treasurer_email, format: /@/, unless: Proc.new {|u| u.treasurer_email.blank? }
  validates :treasurer_first_name, presence: true, unless: Proc.new {|u| u.treasurer_email.blank? }

  def default_event
    events.last
  end

  def treasurer?
    true unless treasurer_email.blank?
  end

  def treasurer_name
    (treasurer_first_name || '') + ' ' + (treasurer_last_name || '')
  end

  def inventory(product)
    stocks.where.not(location: 'take orders').where(product_id: product.id).sum(:quantity)
  end
end