class Ledger < ApplicationRecord
  belongs_to :account
  belongs_to :take_order, optional: true
  belongs_to :take_order_line_item, optional: true
  belongs_to :stock, optional: true
  
  before_destroy { |ledger| 
  }

  validates :account_id, presence: true

  after_save :send_bank_deposit_notifications!, if: Proc.new {|l| l.is_bank_deposit && l.amount < 0 && bank_deposit_notification_sent_at.nil? }
  
  attr_accessor :is_bank_deposit, :from_account_id


  def self.expenses
    joins(:account).where("accounts.acount_type = 'Expense'")
  end

  def send_bank_deposit_notifications!
    if created_by
      Thread.new do
        BankDepositMailer.send_confirmation_email_to_depositer(self.created_by, self).deliver_now
        BankDepositMailer.send_confirmation_email_to_treasurer(self.created_by, self).deliver_now
        self.update(bank_deposit_notification_sent_at: Time.now)
      end
    end
  end
end
