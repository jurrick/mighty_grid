module MightyGrid
  class Column

    attr_reader :attribute, :attrs, :th_attrs, :options, :title
    attr_accessor :render_value

    def initialize(attr_or_options=nil, options=nil, &block)
      @attrs = {}
      @th_attrs = {}
      if block_given?
        @options = attr_or_options || {}
        @render_value = block
      else
        @options = options || {}
        @attribute = attr_or_options
        @render_value = @attribute
      end
      @attrs = @options[:html] if @options.has_key?(:html)
      @th_attrs = @options[:th_html] if @options.has_key?(:th_html)
      @title = @options.has_key?(:title) && @options[:title] || ''
    end

    def render(record)
      case @render_value
        when String, Symbol
          return record[@render_value]
        when Proc
          value = @render_value.call(record)
          return ERB::Util.h(value).to_s.html_safe
        else
          # raise
      end
    end

  end
end