require 'capybara/rspec'
require 'capybara/dsl'

RSpec.configure do |config|
  config.include Capybara::DSL
end

Capybara.configure do |config|
  config.run_server = false
end
