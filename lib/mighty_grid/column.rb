module MightyGrid
  class Column

    attr_reader :display_property, :attribute, :attrs, :th_attrs, :options, :title
    attr_accessor :render_value

    def initialize(attr_or_options=nil, options=nil, &block)
      @attrs = {}
      if block_given?
        @options = attr_or_options
        @display_property = :block
        @render_value = block
        @attrs = options[:html] if options && options.has_key?(:html)
        @th_attrs = options[:th_html] if options && options.has_key?(:th_html)
        @title = options[:title] || ''
      else
        @options = options
        @attribute = attr_or_options
        @display_property = :attr
        @render_value = attribute
        @attrs = options[:html] if options && options.has_key?(:html)
        @th_attrs = options[:th_html] if options && options.has_key?(:th_html)
        @title = options[:title] || ''
      end
    end

    def render(record)
      case @display_property
        when :attr
          return record[@render_value]
        when :block
          value = @render_value.call(record)
          return ERB::Util.h(value).to_s.html_safe
        else
          # raise
      end
    end

  end
end