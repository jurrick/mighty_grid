module MightyGrid
  class Base
    attr_reader :klass, :name, :relation, :options, :mg_params, :controller
    attr_accessor :output_buffer, :filters

    def initialize(klass_or_relation, controller, opts = {})  #:nodoc:
      @controller = controller

      @filters = {}

      @options = {
        :page       => 1,
        :per_page   => MightyGrid.config.per_page,
        :name       => MightyGrid.config.grid_name,
        :include    => nil,
        :joins      => nil,
        :conditions => nil,
        :group      => nil
      }

      opts.assert_valid_keys(@options.keys)
      @options.merge!(opts)

      @name = @options[:name].to_s

      @relation = klass_or_relation

      @klass = klass_or_relation.is_a?(ActiveRecord::Relation) ? klass_or_relation.klass : klass_or_relation

      load_grid_params
    end

    def read
      apply_filters
      @relation = @relation.order("#{@mg_params[:order]} #{current_order_direction.to_sym}") if @mg_params[:order].present? && current_order_direction.present?
      @relation = @relation
                    .page(@mg_params[:page])
                    .per(@mg_params[:per_page])
                    .includes(@options[:include])
                    .joins(@options[:joins])
                    .where(@options[:conditions])
                    .group(@options[:group])
    end

    # Apply filters
    def apply_filters
      filter_params.each do |filter_name, filter_value|
        name, table_name = filter_name.split('.').reverse

        if table_name && Object.const_defined?(table_name.classify)
          model = table_name.classify.constantize
        else
          model = klass
        end

        next if filter_value.blank? || !model.column_names.include?(name)

        if model && model.superclass == ActiveRecord::Base
          field_type = model.columns_hash[name].type
        else
          next
        end

        table_name = model.table_name
        if @filters.key?(filter_name.to_sym) && @filters[filter_name.to_sym].is_a?(Array)
          @relation = @relation.where(table_name => { filter_name => filter_value })
        elsif field_type == :boolean
          value = %w(true 1 t).include?(filter_value) ? true : false
          @relation = @relation.where(table_name => { filter_name => value })
        elsif [:string, :text].include?(field_type)
          @relation = @relation.where("#{table_name}.#{name} #{like_operator} ?", "%#{filter_value}%")
        end
      end
    end

    # Get controller parameters
    def params
      @controller.params
    end

    # Load grid parameters
    def load_grid_params
      @mg_params = {}
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

    # Get filter parameters
    def filter_params
      get_current_grid_param(filter_param_name) || {}
    end

    # Get filter parameter name
    def filter_param_name
      'f'
    end

    # Get filter name by field
    def get_filter_name(field, model = nil)
      field_name = model.present? ? "#{model.table_name}.#{field}" : field
      "#{name}[#{filter_param_name}][#{field_name}]"
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
      current_grid_params.key?('order_direction') ? (%w(asc desc) - [current_grid_params['order_direction'].to_s]).first : MightyGrid.config.order_direction
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
