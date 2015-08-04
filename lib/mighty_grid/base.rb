module MightyGrid
  class Base
    include MightyGrid::Filters
    include MightyGrid::Parameters

    attr_reader :klass, :name, :relation, :options, :mg_params, :params, :controller, :use_sphinx, :sphinx_options
    attr_accessor :output_buffer, :filters, :query

    def initialize(params, opts = {})  #:nodoc:
      @controller_params = params

      # Get active controller through params
      if controller = "#{params[:controller].camelize}Controller".safe_constantize
        @controller = ObjectSpace.each_object(controller).first
      end

      @filters = self.class.filters.dup
      @query = self.class.try(:query).try(:dup)
      @use_sphinx = self.class.use_sphinx || false
      @sphinx_options = {}

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
      attr_reader :klass, :relation, :use_sphinx, :sphinx_options

      def scope(&block)
        if block_given?
          klass_or_relation = yield
          @relation = klass_or_relation
          @klass = klass_or_relation.is_a?(ActiveRecord::Relation) ? klass_or_relation.klass : klass_or_relation
        end
      end

      def use_thinking_sphinx(bool=false)
        fail MightyGrid::Exceptions::ArgumentError.new('Parameter should have type Boolean: true or false') unless bool.in? [true, false]
        @use_sphinx = bool
      end

      def sphinx_options(options = {})
        @sphinx_options = options
      end
    end

    def read
      search_apply_filter if @use_sphinx

      if @use_sphinx && @query
        ts_apply_filters
        if @mg_params[:order].present? && current_order_direction.present? && !@mg_params[:order].kind_of?(Hash)
          @sphinx_options.merge!(order: "#{@mg_params[:order]} #{current_order_direction.to_sym}")
        else
          @sphinx_options.merge!(order: @mg_params[:order])
        end

        @relation = @klass.search(ThinkingSphinx::Query.escape(@query), @sphinx_options)
      else
        ar_apply_filters
        if @mg_params[:order].present? && current_order_direction.present? && !@mg_params[:order].kind_of?(Hash)
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
