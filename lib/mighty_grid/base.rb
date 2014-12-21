module MightyGrid
  class Base
    include MightyGrid::Filters

    attr_reader :klass, :name, :relation, :options, :mg_params, :params, :controller
    attr_accessor :output_buffer, :filters

    def initialize(params, opts = {})  #:nodoc:
      @controller_params = params

      # Get active controller through params
      if controller = "#{params[:controller].camelize}Controller".safe_constantize
        @controller = ObjectSpace.each_object(controller).first
      end

      @filters = self.class.filters.dup

      @options = {
        page:       1,
        per_page:   MightyGrid.per_page,
        name:       MightyGrid.grid_name,
        include:    nil,
        joins:      nil,
        conditions: nil,
        group:      nil,
        order:      nil
      }

      opts.assert_valid_keys(@options.keys)
      @options.merge!(opts)

      @klass = self.class.klass
      @relation = self.class.relation

      @relation = yield(@relation) if block_given?

      @name = @options[:name].to_s

      load_grid_params
    end

    class << self
      attr_reader :klass, :relation

      def scope(&block)
        if block_given?
          klass_or_relation = yield
          @relation = klass_or_relation
          @klass = klass_or_relation.is_a?(ActiveRecord::Relation) ? klass_or_relation.klass : klass_or_relation
        end
      end
    end

    def read
      apply_filters
      if @mg_params[:order].present? && current_order_direction.present?
        @relation = @relation.order("#{@mg_params[:order]} #{current_order_direction.to_sym}")
      else
        @relation = @relation.order(@mg_params[:order])
      end

      @relation = @relation
                    .page(@mg_params[:page])
                    .per(@mg_params[:per_page])
                    .includes(@options[:include])
                    .joins(@options[:joins])
                    .where(@options[:conditions])
                    .group(@options[:group])
    end

    # Load grid parameters
    def load_grid_params
      @mg_params = {}
      @mg_params[filter_param_name.to_sym] = {}
      @mg_params.merge!(@options)
      if current_grid_params
        @mg_params.merge!(current_grid_params.symbolize_keys)
        if @mg_params[:order].present? && !@mg_params[:order].to_s.include?('.')
          @mg_params[:order] = "#{klass.table_name}.#{@mg_params[:order]}"
        end
      end
    end

    # Get current grid parameter by name
    def get_current_grid_param(name)
      current_grid_params.key?(name) ? current_grid_params[name] : nil
    end

    # Get current grid parameters
    def current_grid_params
      params[name] || {}
    end

    # Get order parameters
    def order_params(attribute, model = nil, direction = nil)
      order = model.present? ? "#{model.table_name}.#{attribute}" : attribute.to_s
      direction ||= order == current_grid_params['order'] ? another_order_direction : 'asc'
      { @name => { order: order, order_direction: direction } }
    end

    # Get current order direction if current order parameter coincides with the received parameter
    def get_active_order_direction(parameters)
      parameters[@name]['order'] == current_grid_params['order'] ? current_order_direction : nil
    end

    # Get current order direction
    def current_order_direction
      direction = nil
      if current_grid_params.key?('order_direction') && %w(asc desc).include?(current_grid_params['order_direction'].downcase)
        direction = current_grid_params['order_direction'].downcase
      end
      direction
    end

    # Get another order direction
    def another_order_direction
      current_grid_params.key?('order_direction') ? (%w(asc desc) - [current_grid_params['order_direction'].to_s]).first : MightyGrid.order_direction
    end

    # Get controller parameters
    def params
      @controller_params
    end

    # Get <tt>like</tt> or <tt>ilike</tt> operator depending on the database adapter
    def like_operator
      if ActiveRecord::ConnectionAdapters.const_defined?(:PostgreSQLAdapter) && ActiveRecord::Base.connection.is_a?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
        'ILIKE'
      else
        'LIKE'
      end
    end
  end
end
