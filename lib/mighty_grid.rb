require 'kaminari'
require 'action_view'
require 'mighty_grid/helpers/view_helpers'

module MightyGrid
  extend ActiveSupport::Autoload

  autoload :Base
  autoload :Column
  autoload :GridRenderer
  autoload :FilterRenderer

  @@configured = false

  def self.configured? #:nodoc:
    @@configured
  end

  mattr_accessor :grid_name
  @@grid_name = 'grid'

  mattr_accessor :per_page
  @@per_page = 15

  mattr_accessor :order_direction
  @@order_direction = 'asc'

  mattr_accessor :order_type
  @@order_type = 'single'

  mattr_accessor :order_asc
  @@order_asc = '&uarr;'

  mattr_accessor :order_desc
  @@order_desc = '&darr;'

  mattr_accessor :order_asc_link_class
  @@order_asc_link_class = ''

  mattr_accessor :order_desc_link_class
  @@order_desc_link_class = ''

  mattr_accessor :order_active_link_class
  @@order_active_link_class = 'mg-order-active'

  mattr_accessor :order_wrapper_class
  @@order_wrapper_class = ''

  mattr_accessor :table_class
  @@table_class = ''

  mattr_accessor :header_tr_class
  @@header_tr_class = ''

  mattr_accessor :pagination_theme
  @@pagination_theme = 'mighty_grid'

  def self.setup
    @@configured = true
    yield self
  end
end

require 'mighty_grid/mighty_grid_misc'
require 'mighty_grid/mighty_grid_ext'
require 'mighty_grid/controller'

require 'mighty_grid/engine'
