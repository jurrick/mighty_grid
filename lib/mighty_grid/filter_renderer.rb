module MightyGrid
  class FilterRenderer
    include ActionView::Helpers

    def initialize(grid, view)
      @grid = grid
    end

    # Get <tt>label</tt> HTML tag
    def label(name, content_or_options = nil, options = nil, &block)
      options = content_or_options if content_or_options.is_a?(Hash)
      human_name = (content_or_options.is_a?(Hash) || content_or_options.nil?) ? @grid.klass.human_attribute_name(name) : content_or_options

      f_options = filter_options(name, options, false)

      label_tag(get_filter_id(f_options), human_name, options, &block)
    end

    # Get <tt>input</tt> HTML tag
    def text_field(name, options={})
      f_options = filter_options(name, options)
      text_field_tag(@grid.get_filter_name(name, f_options[:model]), get_filter_param(name, f_options[:model]), options)
    end

    # Get <tt>select</tt> HTML tag
    def select(name, option_tags=nil, options={})
      @grid.filters[name] = option_tags
      selected = nil
      selected = options.delete(:selected) if options.has_key?(:selected)
      
      f_options = filter_options(name, options)

      selected = get_filter_param(name, f_options[:model]) if get_filter_param(name, f_options[:model])
      opts = options_for_select(option_tags, selected)

      select_tag(@grid.get_filter_name(name, f_options[:model]), opts, options)
    end

    # Get <tt>checkbox</tt>
    def check_box(name, value = '1', checked = false, options = {})
      checked = true if get_filter_param(name)

      f_options = filter_options(name, options)
      
      check_box_tag(@grid.get_filter_name(name, f_options[:model]), value, checked, options)
    end

    # Get button for Apply filter changes
    def submit(content = nil, options = {})
      content = I18n.t("mighty_grid.filters.submit", default: 'Apply changes') if content.blank?
      options.merge!(type: :submit)
      content_tag(:button, content, options)
    end

    # Get button for Reset filter changes
    def reset(content = nil, options = {})
      content = I18n.t("mighty_grid.filters.reset", default: 'Reset changes') if content.blank?
      options.merge!(type: :reset)
      content_tag(:button, content, options)
    end

    private

      def get_filter_param(name, model = nil)
        filter_name = model ? "#{model.table_name}.#{name}" : name
        @grid.filter_params.has_key?(filter_name) ? @grid.filter_params[filter_name] : nil
      end

      def get_filter_id(name: nil, model: nil)
        @grid.get_filter_name(name, model).parameterize('_')
      end

      def filter_options(name, options, with_id = true)
        opts = {name: name}
        if options.is_a?(Hash) && options.has_key?(:model)
          model = options.delete(:model)
          raise MightyGridArgumentError.new("Model of field for filtering should have type ActiveRecord") if model.present? && model.superclass != ActiveRecord::Base
          opts.merge!(model: model)
          options.merge!(id: get_filter_id(opts)) if with_id
        end
        opts
      end
  end
end