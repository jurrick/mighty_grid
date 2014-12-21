module MightyGrid
  class Base
    include MightyGrid::Filters
    include MightyGrid::Parameters

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
