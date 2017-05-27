require 'simplecov'
SimpleCov.start


SimpleCov.start do
  add_group "Models", "app/models"
  add_group "Controllers", "app/controllers"
  add_group "Long files" do |src_file|
    src_file.lines.count > 100
  end
  add_group "Multiple Files", ["app/models", "app/controllers"] # You can also pass in an array
end


ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/rails/capybara'
require 'application_helper'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  # Add more helper methods to be used by all tests here...

  def sign_in(scout)
    post '/sessions', params: { email: scout.email, password: 'password'}
  end

  def capybara_login(scout)
    visit root_path
    fill_in '_email', with: scout.email
    fill_in '_password', with: 'password'
    click_button 'Log in'
  end
end