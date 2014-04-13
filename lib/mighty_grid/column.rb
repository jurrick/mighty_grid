module MightyGrid
  class Column

    attr_reader :display_property
    attr_accessor :render_value, :attrs

    def initialize(attr_or_options=nil, options=nil, &block)
      @attrs = {}
      if block_given?
        @display_property = :block
        @render_value = block
        @attrs = attr_or_options[:html] if attr_or_options && attr_or_options.has_key?(:html)
      else
        @display_property = :attr
        @render_value = attr_or_options
        @attrs = options[:html] if options && options.has_key?(:html)
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