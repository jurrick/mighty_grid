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

      label_tag(get_filter_id(name), human_name, options, &block)
    end

    # Get <tt>input</tt> HTML tag
    def text_field(name, options = {})
      text_field_tag(@grid.get_filter_name(name), get_filter_param(name), options)
    end

    # Get <tt>select</tt> HTML tag
    def select(name, options = {})
      option_tags = @grid.filters[name].collection

      selected = nil
      if options.key?(:selected)
        selected = options.delete(:selected)
        @grid.add_filter_param(name, selected)
      end

      selected = get_filter_param(name) if get_filter_param(name)
      opts = options_for_select(option_tags, selected)

      select_tag(@grid.get_filter_name(name), opts, options)
    end

    # Get <tt>checkbox</tt>
    def check_box(name, value = '1', checked = false, options = {})
      checked = true if get_filter_param(name)

      check_box_tag(@grid.get_filter_name(name), value, checked, options)
    end

    # Get button for Apply filter changes
    def submit(content = nil, options = {})
      content = I18n.t('mighty_grid.filters.submit', default: 'Apply changes') if content.blank?
      options.merge!(type: :submit)
      content_tag(:button, content, options)
    end

    # Get button for Reset filter changes
    def reset(content = nil, options = {})
      content = I18n.t('mighty_grid.filters.reset', default: 'Reset changes') if content.blank?
      options.merge!(type: :reset)
      content_tag(:button, content, options)
    end

    private

    def get_filter_param(name)
      if @grid.filter_params.key?(name.to_s)
        @grid.filter_params[name.to_s]
      elsif @grid.filter_params.blank? && @grid.filters[name.to_sym].default.present?
        @grid.filters[name.to_sym].default
      else
        nil
      end
    end

    def get_filter_id(name)
      @grid.get_filter_name(name).parameterize('_')
    end
  end
end
