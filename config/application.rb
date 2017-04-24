require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Popcorn
  class Application < Rails::Application
    config.time_zone = "Pacific Time (US & Canada)"
    config.application_name = 'Corn Cub'
    config.allow_for_multiple_units = true
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end