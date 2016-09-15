class Account < ApplicationRecord
  belongs_to :unit
  has_many :ledgers
  has_many :take_orders

  def self.site_sale(unit)
    Account.where(unit_id: unit.id).where(name: 'Site Sale').first
  end

  def self.take_order(unit)
    Account.where(unit_id: unit.id).where(name: 'Take Order').first
  end

  def balance
    ledgers.sum(:amount)
  end
end
