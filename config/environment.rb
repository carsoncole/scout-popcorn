# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# ActionMailer::Base.delivery_method = :smtp

# ActionMailer::Base.smtp_settings = {
#   address: "smtp.gmail.com",
#   port: 587,
#   domain: "gmail.com",
#   authentication: :login,
#   enable_starttls_auto: true,
#   user_name: "name@gmail.com",
#   password: "password"
#  }