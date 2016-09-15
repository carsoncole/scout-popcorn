class Ledger < ApplicationRecord
  belongs_to :unit
  belongs_to :account
  belongs_to :take_order
  
  attr_accessor :is_bank_deposit, :from_account_id
end
