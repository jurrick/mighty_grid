module MightyGrid
  class FilterRenderer
    include ActionView::Helpers

    def initialize(grid, view)
      @grid = grid
    end

    def label(name, content_or_options = nil, options = nil, &block)
      filter_name = @grid.get_filter_name(name).parameterize('_')
      label_tag(filter_name, content_or_options, options, &block)
    end

    def text_field(name, options={})
      text_field_tag(@grid.get_filter_name(name), get_filter_param(name), options)
    end

    def select(name, option_tags=nil, options={})

      @grid.filters[name] = option_tags
      selected = nil
      selected = options.delete(:selected) if options.has_key?(:selected)
      selected = get_filter_param(name) if get_filter_param(name)
      opts = options_for_select(option_tags, selected)

      select_tag(@grid.get_filter_name(name), opts, options)
    end

    def check_box(name, value = '1', checked = false, options = {})
      checked = true if get_filter_param(name)
      
      check_box_tag(@grid.get_filter_name(name), value, checked, options)
    end

    def submit(content = nil, options = {})
      content = I18n.t("mighty_grid.filters.submit", default: 'Apply changes') if content.blank?
      options.merge!(type: :submit)
      content_tag(:button, content, options)
    end

    def reset(content = nil, options = {})
      content = I18n.t("mighty_grid.filters.reset", default: 'Reset changes') if content.blank?
      options.merge!(type: :reset)
      content_tag(:button, content, options)
    end

    private

      def get_filter_param(name)
        @grid.filter_params.has_key?(name) ? @grid.get_current_grid_param(@grid.filter_param_name)[name] : nil
      end
  end
end