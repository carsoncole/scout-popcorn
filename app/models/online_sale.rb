class OnlineSale < ApplicationRecord
  belongs_to :scout
  belongs_to :event
  has_many :ledgers

  validates :scout_id, :event_id, :amount, :customer_name, presence: true
  validates :amount, numericality: true

  after_create :process_to_ledgers!
  before_destroy :reverse_ledgers!

  def process_to_ledgers!
    double_entry = DoubleEntry.create

    # expense
    online_costs_account = event.accounts.where(name: 'Online costs').first
    online_costs_account.ledgers.create(account_id: online_costs_account.id, amount: amount * event.online_wholesale_percentage, date: self.order_date, online_sale_id: self.id, double_entry_id: double_entry.id)

    # asset
    due_from_bsa_account = event.accounts.where(name: 'Due from BSA - Online sales').first
    due_from_bsa_account.ledgers.create(account_id: due_from_bsa_account.id, amount: amount * (1 - event.online_wholesale_percentage), date: self.order_date, online_sale_id: self.id, double_entry_id: double_entry.id)
  end

  def reverse_ledgers!
    ledgers.destroy_all
  end

end