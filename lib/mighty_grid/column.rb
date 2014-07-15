module MightyGrid
  class Column
    attr_reader :attribute, :attrs, :th_attrs, :options, :title, :model, :partial
    attr_accessor :render_value

    def initialize(options = {}, &block)
      @attrs = {}
      @th_attrs = {}

      @attribute = options.delete(:attribute) if options.key?(:attribute)

      @options ||= options

      if block_given?
        @render_value = block
      else
        @render_value = @attribute
      end

      @model = @options[:model]
      fail MightyGridArgumentError.new('Model of field for filtering should have type ActiveRecord') if @model && @model.superclass != ActiveRecord::Base

      @attrs = @options[:html] if @options.key?(:html)
      @th_attrs = @options[:th_html] if @options.key?(:th_html)
      @title = @options.key?(:title) && @options[:title] || ''
    end

    def render(record)
      case @render_value
      when String, Symbol
        rec = @model ? record.send(@model.to_s.underscore) : record
        return rec[@render_value]
      when Proc
        value = @render_value.call(record)
        return ERB::Util.h(value).to_s.html_safe
      else
        # raise
      end
    end
  end
end
