class ScoutMailer < ApplicationMailer
  default from: "Pack 4496 <pack4496@gmail.com>"
  default to: "carson.cole@gmail.com"

  def registration(scout)
    @scout = scout
    mail(subject: "Corn Cub registration by: #{scout.name}")
  end

  def you_are_registered(scout)
    @scout = scout
    mail(subject: "Welcome to Pack 4496's Corn Cub", to: scout.email)
  end

end