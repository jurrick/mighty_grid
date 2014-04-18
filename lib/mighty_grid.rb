require 'mighty_grid/version'
require 'mighty_grid/mighty_grid_ext'
require 'mighty_grid/column'
require 'mighty_grid/grid_renderer'
require 'mighty_grid/helpers/mighty_grid_view_helpers'
require 'mighty_grid/mighty_grid_controller'

require 'kaminari.rb'

module MightyGrid

  class MightyGridEngine < ::Rails::Engine
    initializer 'mighty_grid_railtie.configure_rails_initialization' do |app|

      ActiveSupport.on_load :action_controller do
        ActionController::Base.send(:include, MightyGrid::Controller)
      end

      ActiveSupport.on_load :action_view do
        ::ActionView::Base.class_eval { include MightyGrid::GridViewHelper }

        # It is here only until this pull request is pulled: https://github.com/amatsuda/kaminari/pull/267
        require 'mighty_grid/kaminari_monkey_patching'
      end

    end
  end

  class Base

    attr_reader :klass, :name, :relation, :options, :mg_params
    attr_accessor :output_buffer

    def initialize(klass_or_relation, controller, opts = {})  #:nodoc:
      @controller = controller

      @options = {
        page: 1,
        per_page: 10,
        name: 'grid'
      }

      opts.assert_valid_keys(@options.keys)
      @options.merge!(opts)

      @name = @options[:name].to_s

      load_grid_params

      @relation = klass_or_relation

      @klass = klass_or_relation.is_a?(ActiveRecord::Relation) ? klass_or_relation.klass : klass_or_relation

    end

    def read
      @relation = @relation.order(@mg_params[:order] => @mg_params[:order_direction].to_sym) if @mg_params[:order].present? && @mg_params[:order_direction].present?
      @relation = @relation.page(@mg_params[:page]).per(@mg_params[:per_page])
    end

    def params
      @controller.params
    end

    def load_grid_params
      @mg_params = {}
      @mg_params.merge!(@options)
      if current_grid_params
        @mg_params.merge!(current_grid_params.symbolize_keys)
      end
    end

    def current_grid_params
      params[name] || {}
    end

    def order_direction
      (current_grid_params.has_key?('order_direction')) ? (['asc', 'desc'] - [current_grid_params['order_direction']]).first : 'asc'
    end

  end
end