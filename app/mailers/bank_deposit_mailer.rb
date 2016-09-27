class BankDepositMailer < ApplicationMailer
  default from: "Pack 4496 <pack4496@gmail.com>"
  default bcc: "Carson Cole <carson.cole@gmail.com>"

  def send_confirmation_email_to_depositer(scout_id, ledger)
    @scout = Scout.find(scout_id)
    @ledger = ledger
    @unit = @scout.unit
    to = @scout.email
    mail(to: to, subject: "Thank you for making a #{@scout.unit.name} deposit")
  end

  def send_confirmation_email_to_treasurer(scout_id, ledger)
    @scout = Scout.find(scout_id)
    @ledger = ledger
    @unit = @scout.unit
    unless @unit.treasurer_email.blank?
      if Rails.env == 'development'
        to = "Test Treasurer <carson.cole+test_treasurer@gmail.com>"
      else
        to = @unit.treasurer_email
      end
      mail(to: to, subject: "A Corn Cub bank deposit was made from #{@ledger.account.name}")
    end
  end
end