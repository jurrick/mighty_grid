require 'mighty_grid/version'
require 'mighty_grid/column'
require 'mighty_grid/grid_renderer'
require 'mighty_grid/helpers/mighty_grid_view_helpers'
require 'mighty_grid/mighty_grid_controller'

module MightyGrid
  # Your code goes here...
  class MightyGridEngine < ::Rails::Engine
    initializer 'mighty_grid_railtie.configure_rails_initialization' do |app|

      ActiveSupport.on_load :action_controller do
        ActionController::Base.send(:include, MightyGrid::Controller)
      end

      ActiveSupport.on_load :action_view do
        ::ActionView::Base.class_eval { include MightyGrid::GridViewHelper }
      end

    end
  end

  class Base

    attr_reader :klass, :relation

    attr_accessor :output_buffer

    def initialize(klass_or_relation, controller, opts = {})  #:nodoc:
      @controller = controller

      @relation = klass_or_relation

      @klass = klass_or_relation.is_a?(ActiveRecord::Relation) ? klass_or_relation.klass : klass_or_relation

    end

  end
end