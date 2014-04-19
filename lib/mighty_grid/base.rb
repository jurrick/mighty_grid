module MightyGrid

  class Base

    attr_reader :klass, :name, :relation, :options, :mg_params
    attr_accessor :output_buffer

    def initialize(klass_or_relation, controller, opts = {})  #:nodoc:
      @controller = controller

      @options = {
        page: 1,
        per_page: MightyGrid.config.per_page,
        name: MightyGrid.config.grid_name
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
      (current_grid_params.has_key?('order_direction')) ? (['asc', 'desc'] - [current_grid_params['order_direction']]).first : MightyGrid.config.order_direction
    end

  end
end