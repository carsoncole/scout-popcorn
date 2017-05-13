class Account < ApplicationRecord
  belongs_to :event
  has_many :ledgers
  has_many :take_orders, foreign_key: :payment_id
  has_many :site_sale_payment_methods

  ACCOUNT_TYPES = ['Asset', 'Liability', 'Equity', 'Income', 'Expense']

  validates :name, :account_type, presence: true
  validates :account_type, inclusion: { in: ACCOUNT_TYPES }
  validates :name, uniqueness: { scope: :event } 

  def self.site_sale(event)
    Account.where(event_id: event.id).where(name: 'Site Sales cash').first
  end

  def self.take_order(event)
    Account.where(event_id: event.id).where(name: 'Take Orders cash').first
  end

  def self.money_due_from_customer(event)
    Account.where(event_id: event.id).where(name: 'Money due from Customer').first
  end

  def self.due_to_bsa(event)
    Account.where(event_id: event.id).where(name: 'Due to BSA').first
  end  

  def self.due_to_unit(event)
    Account.where(event_id: event.id).where(name: 'Due to Unit').first
  end 

  def self.is_take_order_eligible
    where(is_take_order_eligible: true)
  end

  def self.assets
    where(account_type: 'Asset')
  end

  def self.liabilities
    where(account_type: 'Liability')
  end

  def self.cash
    where(is_cash: true)
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
    create(event_id: event.id, name: 'Site Sales cash', is_cash: true, is_site_sale_eligible: true, account_type: 'Asset', rank: 1)
  end

  def self.create_take_orders_cash!(event)
    create(event_id: event.id, name: 'Take Orders cash', is_cash: true, is_take_order_eligible: true, account_type: 'Asset',rank: 1)
  end

  def self.create_bank_accounts!(event)
    create(event_id: event.id, name: 'Unit bank account', is_cash: false, is_bank_account_depositable: true, account_type: 'Asset', rank: 2)
    create(event_id: event.id, name: 'BSA bank account', is_cash: false, is_bank_account_depositable: true, account_type: 'Asset', rank: 2)
  end

  def self.create_money_due_from_customers!(event)
    create(event_id: event.id, name: 'Due from customers', is_cash: false, is_take_order_eligible: true, account_type: 'Asset', rank: 3)
  end

  def self.create_inventory!(event)
    create(event_id: event.id, name: 'Inventory', is_cash: false, account_type: 'Asset', rank: 10)
  end

  def self.create_product_due_to_customers!(event)
    create(event_id: event.id, name: 'Product due to customers', is_cash: false, account_type: 'Liability')
  end

  def self.create_money_due_to_bsa!(event)
    create(event_id: event.id, name: 'Due to BSA', is_cash: false, is_due_to_bsa: true, account_type: 'Liability')
  end

  def self.create_money_due_to_unit!(event)
    create(event_id: event.id, name: 'Due to Unit', is_cash: false, account_type: 'Liability')
  end

  def self.create_third_party_account!(event)
    create(event_id: event.id, name: 'Third Party account', is_third_party_account: true, is_site_sale_eligible: true, is_cash: false, account_type: 'Asset', rank: 4)
  end

end