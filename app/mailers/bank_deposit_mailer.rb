class BankDepositMailer < ApplicationMailer
  default from: "Pack 4496 <pack4496@gmail.com>"
  # default to: "Candace Luckman <cluckman@gmail.com>"
  default to: "Carson Cole <carson.cole@gmail.com>"

  def send_confirmation_email_to_depositer(scout_id, ledger)
    @scout = Scout.find(scout_id)
    @ledger = ledger
    to = @scout.email
    mail(to: to, subject: "Thank you for making a #{@scout.unit.name} deposit")
  end

  def send_confirmation_email_to_treasurer(scout_id, ledger)
    @scout = Scout.find(scout_id)
    @ledger = ledger
    mail(subject: "A Corn Cub bank deposit was made from #{@ledger.account.name}")
  end
end
