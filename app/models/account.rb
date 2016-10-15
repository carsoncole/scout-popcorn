class Account < ApplicationRecord
  belongs_to :event
  has_many :ledgers
  has_many :take_orders, foreign_key: :payment_id
  has_many :site_sale_payment_methods

  ACCOUNT_TYPES = ['Asset', 'Liability', 'Equity', 'Income', 'Expense']
  REQUIRED_ASSET_ACCOUNTS = ['Take Order Cash', 'Site Sale Cash']

  def self.create_site_sales_cash(event)
    create(event_id: event.id, name: 'Site Sales Cash', is_cash: true, is_site_sale_eligible: true, account_type: 'Asset')
  end

  def self.create_take_orders_cash(event)
    create(event_id: event.id, name: 'Take Orders Cash', is_cash: true, is_take_order_eligible: true, account_type: 'Asset')
  end

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

  def balance(args={})
    if args[:site_sales]
      ledgers.where.not(site_sale_id: nil).sum(:amount)
    elsif args[:take_orders]
      ledgers.where.not(take_order_id: nil).sum(:amount)
    else
      ledgers.sum(:amount)
    end
  end
end