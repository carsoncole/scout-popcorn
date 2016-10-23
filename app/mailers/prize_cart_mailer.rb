class PrizeCartMailer < ApplicationMailer
  default from: "Pack 4496 <pack4496@gmail.com>"

  def receipt(prize_cart)
    @scout = prize_cart.scout
    @unit = @scout.unit
    @event = prize_cart.event
    @prize_cart = prize_cart
    if prize_cart.ordered?
      mail(to: prize_cart.scout.email, subject: "#{@unit.name} #{@event.name} Prize order received")
    end
  end
end
