require 'active_support/configurable'

module MightyGrid
  # Configures global settings for MightyGrid
  #   MightyGrid.configure do |config|
  #     config.grid_name = 'g'
  #   end
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
    config_accessor :order_type
    config_accessor :order_asc
    config_accessor :order_desc
    config_accessor :order_asc_link_class
    config_accessor :order_desc_link_class
    config_accessor :order_active_link_class
    config_accessor :order_wrapper_class
    config_accessor :grid_name
    config_accessor :header_tr_class
    config_accessor :table_class
    config_accessor :pagination_theme
  end

  configure do |config|
    config.per_page = 15
    config.order_direction = 'asc'
    config.order_type = 'single'
    config.order_asc = '&uarr;'
    config.order_desc = '&darr;'
    config.order_asc_link_class = ''
    config.order_desc_link_class = ''
    config.order_active_link_class = 'mg-order-active'
    config.order_wrapper_class = ''
    config.grid_name = 'grid'
    config.table_class = ''
    config.header_tr_class = ''
    config.pagination_theme = 'mighty_grid'
  end
end
