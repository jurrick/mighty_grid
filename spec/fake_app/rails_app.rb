require 'action_controller/railtie'
require 'action_view/railtie'

require 'capybara/rspec'

require 'fake_app/models/config'

app = Class.new(Rails::Application)
app.config.secret_token = '7295e7f2718c940f459e5062f575cd92'
app.config.session_store :cookie_store, :key => '_myapp_session'
app.config.active_support.deprecation = :log
app.config.eager_load = false

# Rais.root
app.config.root = File.dirname(__FILE__)
Rails.backtrace_cleaner.remove_silencers!
app.initialize!

# ROUTES
app.routes.draw do
  resources :products
end

# MODELS
require 'fake_app/models/active_record'

# CONTROLLERS
class ApplicationController < ActionController::Base; end
class ProductsController < ApplicationController
  def index
    @products_grid = init_grid(Product)
    render :inline => <<-ERB
<%= grid @products_grid do |g| %>
<% g.column :name %>
<% end %>
ERB
  end
end

# HELPERS
Object.const_set(:ApplicationHelper, Module.new)

Capybara.app = app