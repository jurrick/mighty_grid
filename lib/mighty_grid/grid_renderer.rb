module MightyGrid
  class GridRenderer
    attr_reader :columns, :th_columns

    def initialize(grid, view)
      @columns = []
      @th_columns = []
    end

    def column(attr_or_options = {}, options=nil, &block)
      if block_given?
        options = attr_or_options.symbolize_keys
        @th_columns << {title: options[:title], html: options[:th_html]}
        @columns << MightyGrid::Column.new(options[:html], &block)
      else
        @columns << MightyGrid::Column.new(attr_or_options, options)
        th_column = {title: attr_or_options.to_s.titleize}
        th_column[:html] = options ? options[:th_html] : {}
        @th_columns << th_column
      end
    end
  end
end