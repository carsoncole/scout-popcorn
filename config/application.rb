require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Popcorn
  class Application < Rails::Application
    config.time_zone = "Pacific Time (US & Canada)"
    config.application_name = 'Corn Cub'
    config.allow_for_multiple_units = true

    # email notifications
    config.from_email = 'Pack4496@gmail.com'
    config.bcc_email = 'carson.cole+popcorn@gmail.com'
    config.development_email = ''
  end
end