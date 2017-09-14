class Ledger < ApplicationRecord
  belongs_to :account
  belongs_to :take_order, optional: true
  belongs_to :take_order_line_item, optional: true
  belongs_to :stock, optional: true
  belongs_to :online_sale, optional: true
  belongs_to :double_entry, optional: true

  validates :account_id, presence: true

  after_create :create_deposit_double_entry!, if: Proc.new {|l| l.is_bank_deposit }

  after_save :send_bank_deposit_notifications!, if: Proc.new {|l| l.is_bank_deposit && l.amount < 0 && bank_deposit_notification_sent_at.nil? }
  
  attr_accessor :is_bank_deposit, :from_account_id, :fund_site_sales

  after_destroy :destroy_related_double_entries!, if: Proc.new {|l| l.double_entry_id.present? }

  def self.expenses
    joins(:account).where("accounts.acount_type = 'Expense'")
  end

  def siblings
    Ledger.where("double_entry_id = ?", double_entry_id).where.not("id = ?", self.id)
  end


  def create_deposit_double_entry!
    from_account = Account.find(self.from_account_id)
    @double_entry = Ledger.new(self.attributes.except('id'))
    @double_entry.description = "Bank deposit to #{self.account.name}"
    @double_entry.account_id = from_account.id
    @double_entry.amount = -self.amount
    @double_entry.created_by = self.created_by
    @double_entry.double_entry_id = self.double_entry_id
    @double_entry.save
  end

  def send_bank_deposit_notifications!
    if created_by
      sibling_ledger = self.siblings.first
      # Thread.new do
      BankDepositMailer.send_confirmation_email_to_depositer(self.created_by, self, sibling_ledger).deliver_now!
      BankDepositMailer.send_confirmation_email_to_treasurer(self.created_by, self, sibling_ledger).deliver_now!
      self.update(bank_deposit_notification_sent_at: Time.now)
    end
    # end
  end

  def destroy_related_double_entries!
    Ledger.where(double_entry_id: self.double_entry_id).delete_all
  end
end