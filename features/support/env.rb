begin
  require 'rails'
  require 'rails/generators'
rescue LoadError
end

require 'bundler/setup'
Bundler.require

require 'capybara/cucumber'

if defined? Rails
  require File.expand_path("../../../spec/dummy/config/environment.rb",  __FILE__)
end

require 'spreewald/web_steps'
require 'spreewald/table_steps'
require 'spreewald/development_steps'
