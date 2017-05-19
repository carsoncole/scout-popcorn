class TakeOrderMailer < ApplicationMailer
  default from: Rails.configuration.from_email

  def receipt(take_order)
    @scout = take_order.scout
    @take_order = take_order
    if take_order.customer_email
      mail(to: take_order.customer_email, subject: "Thank you for supporting #{ @scout.unit.name }")
    end
  end
end
