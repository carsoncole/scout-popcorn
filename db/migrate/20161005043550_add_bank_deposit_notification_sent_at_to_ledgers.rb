class AddBankDepositNotificationSentAtToLedgers < ActiveRecord::Migration[5.0]
  def change
    add_column :ledgers, :bank_deposit_notification_sent_at, :datetime
  end
end
