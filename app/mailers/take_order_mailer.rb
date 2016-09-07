class TakeOrderMailer < ApplicationMailer
  default from: "Pack 4496 <pack4496@gmail.com>"

  def receipt(take_order)
    @scout = take_order.scout
    @take_order = take_order
    if take_order.customer_email
      mail(to: take_order.customer_email, subject: "Thank you for supporting Pack 4496")
    end
  end
end
