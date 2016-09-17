class Account < ApplicationRecord
  belongs_to :unit
  has_many :ledgers
  has_many :take_orders
  has_many :site_sale_payment_methods

  ACCOUNT_TYPES = ['Asset', 'Liability', 'Equity']

  def self.site_sale(unit)
    Account.where(unit_id: unit.id).where(name: 'Site Sale').first
  end

  def self.take_order(unit)
    Account.where(unit_id: unit.id).where(name: 'Take Order Cash').first
  end

  def self.is_take_order_eligible
    where(is_take_order_eligible: true)
  end

  def self.assets
    where(account_type: 'Asset')
  end

  def self.is_site_sale_eligible
    where(is_site_sale_eligible: true)
  end

  def self.is_bank_account_depositable
    where(is_bank_account_depositable: true)
  end

  def balance
    ledgers.sum(:amount)
  end
end
