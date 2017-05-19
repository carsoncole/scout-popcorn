class BankDepositMailer < ApplicationMailer
  default from: Rails.configuration.from_email
  
  if Rails.configuration.bcc_email.present?
    default bcc: Rails.configuration.bcc_email
  end

  def send_confirmation_email_to_depositer(scout_id, ledger, sibling_ledger)
    if ActionMailer::Base.smtp_settings[:address] != 'localhost'
      @scout = Scout.find(scout_id)
      @ledger = ledger
      @sibling_ledger = sibling_ledger
      @unit = @scout.unit
      @title = 'Thank you' 
      to = @scout.email
      mail(to: to, subject: "Thank you for making a #{@scout.unit.name} deposit")
    else
      logger.warn("WARNING:  ActionMailer settings must be configured in environment.rb ***")
    end
  end

  def send_confirmation_email_to_treasurer(scout_id, ledger, sibling_ledger)
    if ActionMailer::Base.smtp_settings[:address] != 'localhost'
      @scout = Scout.find(scout_id)
      @ledger = ledger
      @sibling_ledger = sibling_ledger
      @unit = @scout.unit
      @title = 'A ' + Rails.configuration.application_name + ' FYI.'
      unless @unit.treasurer_email.blank?
        if Rails.env == 'development' && Rails.configuration.development_email.present?
          to = Rails.configuration.development_email
        else
          to = @unit.treasurer_email
        end
        mail(to: to, subject: "A #{Rails.configuration.application_name} bank deposit was made from #{@ledger.account.name}")
      end

    else
      logger.warn("WARNING: ActionMailer settings must be configured in environment.rb")
    end
  end
end