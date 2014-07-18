begin
  require 'rails'
  require 'rails/generators'
rescue LoadError
end

require 'capybara/cucumber'
require 'bundler/setup'
Bundler.require

if defined? Rails
  require_relative '../../spec/fake_app/rails_app'
end

require 'spreewald/web_steps'
require 'spreewald/table_steps'
require 'spreewald/development_steps'
