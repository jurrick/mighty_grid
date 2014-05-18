module MightyGrid

  class Base

    attr_reader :klass, :name, :relation, :options, :mg_params
    attr_accessor :output_buffer, :filters

    def initialize(klass_or_relation, controller, opts = {})  #:nodoc:
      @controller = controller

      @filters = {}

      @options = {
        :page     => 1,
        :per_page => MightyGrid.config.per_page,
        :name     => MightyGrid.config.grid_name,
        :include  => nil,
        :joins    => nil,
      }

      opts.assert_valid_keys(@options.keys)
      @options.merge!(opts)

      @name = @options[:name].to_s

      load_grid_params

      @relation = klass_or_relation

      @klass = klass_or_relation.is_a?(ActiveRecord::Relation) ? klass_or_relation.klass : klass_or_relation

    end

    def read
      apply_filters
      @relation = @relation.order(@mg_params[:order] => current_order_direction.to_sym) if @mg_params[:order].present? && current_order_direction.present?
      @relation = @relation.
                    page(@mg_params[:page]).
                    per(@mg_params[:per_page]).
                    includes(@options[:include]).
                    joins(@options[:joins])
    end

    def apply_filters
      filter_params.each do |filter_name, filter_value|
        next if filter_value.blank? || !klass.column_names.include?(filter_name)
        field_type = klass.columns_hash[filter_name].type
        if @filters.has_key?(filter_name.to_sym) && Array === @filters[filter_name.to_sym] || field_type == :boolean
          @relation = @relation.where(filter_name => filter_value)
        elsif [:string, :text].include?(field_type)
          @relation = @relation.where("\"#{klass.table_name}\".\"#{filter_name}\" #{like_operator} ?", "%#{filter_value}%")
        end
      end
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

    def get_current_grid_param(name)
      current_grid_params.has_key?(name) ? current_grid_params[name] : nil
    end

    def filter_params
      get_current_grid_param(filter_param_name) || {}
    end

    def filter_param_name; 'f' end

    def get_filter_name(filter_name)
      "#{name}[#{filter_param_name}][#{filter_name}]"
    end

    def current_grid_params
      params[name] || {}
    end

    def order_params(attribute)
      direction = attribute.to_s == @mg_params[:order] ? another_order_direction : 'asc'
      {@name => {order: attribute, order_direction: direction}}
    end

    def current_order_direction
      direction = nil
      if current_grid_params.has_key?('order_direction') && ['asc', 'desc'].include?(current_grid_params['order_direction'].downcase)
        direction = current_grid_params['order_direction'].downcase
      end
      direction
    end

    def another_order_direction
      (current_grid_params.has_key?('order_direction')) ? (['asc', 'desc'] - [current_grid_params['order_direction'].to_s]).first : MightyGrid.config.order_direction
    end

    def like_operator
      if ActiveRecord::ConnectionAdapters.const_defined?(:PostgreSQLAdapter) && ActiveRecord::Base.connection.is_a?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
        'ILIKE'
      else
        'LIKE'  
      end
    end

  end
end