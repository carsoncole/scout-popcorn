class ScoutMailer < ApplicationMailer
  default from: Rails.configuration.from_email
  
  if Rails.configuration.bcc_email.present?
    default bcc: Rails.configuration.bcc_email
  end

  def registration(scout)
    if scout.unit.send_email_on_registration
      @scout = scout
      mail(subject: "#{Rails.configuration.application_name} registration by: #{scout.name}", to: scout.unit.admin.map {|s| s.email })
    end
  end

  def you_are_registered(scout)
    if scout.unit.send_email_on_registration
      @scout = scout
      mail(subject: "Welcome to #{Rails.configuration.application_name}", to: scout.email)
    end
  end

end