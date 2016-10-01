class Ledger < ApplicationRecord
  belongs_to :unit
  belongs_to :account
  belongs_to :take_order, optional: true

  TREASURER = ['Candace', 'cluckman@gmail.com']

  after_save :send_bank_deposit_notifications!, if: Proc.new {|l| l.is_bank_deposit && l.amount < 0}
  
  attr_accessor :is_bank_deposit, :from_account_id


  def send_bank_deposit_notifications!
    if created_by
      BankDepositMailer.send_confirmation_email_to_depositer(self.created_by, self).deliver_now
      BankDepositMailer.send_confirmation_email_to_treasurer(self.created_by, self).deliver_now
    end
  end
end
