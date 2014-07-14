module MightyGrid
  class GridRenderer
    attr_reader :columns, :th_columns, :blank_slate_handler

    def initialize(grid, view)
      @grid = grid
      @columns = []
      @th_columns = []
      @blank_slate_handler = nil
    end

    def column(attr_or_options = {}, options = nil, &block)
      if attr_or_options.is_a?(Hash)
        options = attr_or_options.symbolize_keys
      else
        attribute = attr_or_options.to_sym
        options = {} unless options.is_a?(Hash)
      end

      if attribute.present?
        options = {
          ordering: true,
          attribute: attribute,
          title: @grid.klass.human_attribute_name(attribute)
        }.merge!(options)
      end

      if block_given?
        @columns << MightyGrid::Column.new(options, &block)
      else
        @columns << MightyGrid::Column.new(options)
      end
    end

    def actions(opts = {})
      options = {
        partial: 'mighty_grid/actions',
        only: [:show, :edit, :destroy]
      }

      opts.assert_valid_keys(options.keys)
      options.merge!(opts)

      @columns << MightyGrid::Column.new(title: 'Actions') { |object| @grid.controller.render_to_string(partial: options[:partial], locals: { actions: options[:only], object: object }) }
    end

    def blank_slate(html_or_opts = nil, &block)
      if (html_or_opts.is_a?(Hash) && html_or_opts.has_key?(:partial) || html_or_opts.is_a?(String)) && !block_given?
        @blank_slate_handler = html_or_opts
      elsif html_or_opts.nil? && block_given?
        @blank_slate_handler = block
      else
        raise MightyGridArgumentError.new("blank_slate accepts only a string, a block, or :partial => 'path_to_partial' ")
      end
    end

    def total_columns
      @columns.count
    end
  end
end
