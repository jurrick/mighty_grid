require 'active_support/configurable'

module MightyGrid
  def self.configure(&block)
    yield @config ||= MightyGrid::Configuration.new
  end

  # Global settings for MightyGrid
  def self.config
    @config
  end

  class Configuration #:nodoc:
    include ActiveSupport::Configurable
    config_accessor :per_page
    config_accessor :order_direction
    config_accessor :grid_name
    config_accessor :table_class
  end

  configure do |config|
    config.per_page = 15
    config.order_direction = 'asc'
    config.grid_name = 'grid'
    config.table_class = ''
  end
end