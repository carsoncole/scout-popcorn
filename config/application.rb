require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Popcorn
  class Application < Rails::Application
    config.time_zone = "Pacific Time (US & Canada)"
    config.application_name = 'Corn Cub'
    config.allow_for_multiple_units = false

    # email notifications
    config.from_email = ''
    config.bcc_email = ''
    config.development_email = ''
  end
end
