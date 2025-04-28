# frozen_string_literal: true

require 'capybara/rspec'
require 'selenium-webdriver'

Capybara.register_driver :firefox do |app|
  options = Selenium::WebDriver::Firefox::Options.new
  options.add_argument('--headless')
  Capybara::Selenium::Driver.new(app, browser: :firefox, options: options)
end

Capybara.javascript_driver = :firefox
