module MightyGrid
  class GridRenderer
    attr_reader :columns, :th_columns, :total_columns

    def initialize(grid, view)
      @columns = []
      @th_columns = []
    end

    def column(attr_or_options = {}, options=nil, &block)
      if block_given?
        options = attr_or_options.symbolize_keys
        @columns << MightyGrid::Column.new(options, &block)
      else
        attribute = attr_or_options.to_sym
        options = {} unless options.is_a?(Hash)
        opts = {
          title: attr_or_options.to_s.titleize,
          ordering: true,
          attribute: attribute
        }.merge!(options)
        @columns << MightyGrid::Column.new(attribute, opts)
      end
      @total_columns = @columns.count
    end
  end
end