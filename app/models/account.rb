class Account < ApplicationRecord
  belongs_to :event
  has_many :ledgers
  has_many :take_orders, foreign_key: :payment_id
  has_many :site_sale_payment_methods

  ACCOUNT_TYPES = ['Asset', 'Liability', 'Equity', 'Income', 'Expense']

  def self.site_sale(unit)
    Account.where(unit_id: unit.id).where(name: 'Site Sale').first
  end

  def self.take_order(event)
    Account.where(event_id: event.id).where(name: 'Take Order Cash').first
  end

  def self.money_due_from_customer(event)
    Account.where(event_id: event.id).where(name: 'Money due from Customer').first
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

  def self.create_site_sales_cash!(event)
    create(event_id: event.id, name: 'Site Sales Cash', is_cash: true, is_site_sale_eligible: true, account_type: 'Asset')
  end

  def self.create_take_orders_cash!(event)
    create(event_id: event.id, name: 'Take Orders Cash', is_cash: true, is_take_order_eligible: true, account_type: 'Asset')
  end

  def self.create_money_due_from_customers!(event)
    create(event_id: event.id, name: 'Money due from customers', is_cash: false, is_take_order_eligible: true, account_type: 'Asset')
  end

  def self.create_product_due_to_customers!(event)
    create(event_id: event.id, name: 'Product due to customers', is_cash: false, account_type: 'Liability')
  end

  def self.create_money_due_to_bsa!(event)
    create(event_id: event.id, name: 'Money due to BSA', is_cash: false, account_type: 'Liability')
  end

  def self.create_bsa_credit_card!(event)
    create(event_id: event.id, name: 'BSA credit card', is_cash: false, account_type: 'Asset')
  end

end