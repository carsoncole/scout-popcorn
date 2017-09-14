class ForgetPasswordMailer < ApplicationMailer
  require 'securerandom'
  default from: "Pack 4496 <#{ Rails.configuration.from_email }>"
  
  if Rails.configuration.bcc_email.present?
    default bcc: Rails.configuration.bcc_email
  end

  def forget(scout_id)
    scout = Scout.find(scout_id)
    @scout = scout
    @title = Rails.configuration.application_name + ' password reset'
    @token = SecureRandom.hex
    scout.update(password_reset_token: @token)
    mail(subject: "#{Rails.configuration.application_name} password reset", to: scout.email)
  end

end