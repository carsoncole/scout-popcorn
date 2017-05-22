class TakeOrderMailer < ApplicationMailer
  default from: Rails.configuration.from_email

  def receipt(take_order)
    @scout = take_order.scout
    return unless @scout.unit.send_emails
    @take_order = take_order
    @title = 'Thank you'
    if take_order.customer_email
      mail(to: take_order.customer_email, subject: "Thank you for supporting #{ @scout.unit.name }")
    end
  end
end
