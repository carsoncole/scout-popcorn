class Ledger < ApplicationRecord
  belongs_to :unit
  belongs_to :account

  attr_accessor :is_bank_deposit
end
