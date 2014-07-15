module MightyGrid
  module GridViewHelper
    def grid(grid, opts = {}, &block)
      define_grid(grid, opts, &block)
      render_grid(grid)
    end

    def define_grid(grid, opts = {}, &block)
      rendering = GridRenderer.new(grid, self)

      block.call(rendering)

      options = {
        html: {},
        header_tr_html: {},
        order_type: MightyGrid.config.order_type,
        order_asc: MightyGrid.config.order_asc,
        order_desc: MightyGrid.config.order_desc,
        order_asc_link_class: MightyGrid.config.order_asc_link_class,
        order_desc_link_class: MightyGrid.config.order_desc_link_class,
        order_active_link_class: MightyGrid.config.order_active_link_class,
        order_wrapper_class: MightyGrid.config.order_wrapper_class
      }

      opts.assert_valid_keys(options.keys)

      options.merge!(opts)

      options[:order_wrapper_class] = MightyGrid::MgHTML.join_html_classes({}, 'mg-order-wrapper', options[:order_wrapper_class])[:class]

      table_html_attrs = MightyGrid::MgHTML.join_html_classes(options[:html], 'mighty-grid', MightyGrid.config.table_class)

      grid.read

      if grid.relation.total_count > 0
        grid.output_buffer = content_tag :table, table_html_attrs do
          html = header_grid_html(rendering, grid, options)
          html += footer_grid_html(rendering, grid)
          html += body_grid_html(rendering, grid)
          html
        end
      else
        grid.output_buffer = blank_slate_template(rendering)
      end
    end

    # Used after <tt>define_grid</tt> to actually output the grid HTML code.
    # Usually used with detached filters: first <tt>define_grid</tt>, then <tt>grid_filter</tt>s, and then
    # <tt>render_grid</tt>
    def render_grid(grid)
      grid.output_buffer.html_safe
    end

    # Creates a form to filter the data in the target grid.
    def mighty_filter_for(grid, options = {}, &block)
      html_options = options[:html] ||= {}
      html_options = MightyGrid::MgHTML.join_html_classes(html_options, 'mighty-grid-filter')
      html_options[:method] = options.delete(:method) if options.key?(:method)
      html_options[:method] ||= :get

      filter = FilterRenderer.new(grid, self)

      output = capture(filter, &block)
      form_tag(options[:url] || {}, html_options) { output }
    end

    def blank_slate_template(rendering)
      if rendering.blank_slate_handler.present?
        case rendering.blank_slate_handler
        when Proc then rendering.blank_slate_handler.call
        when String then rendering.blank_slate_handler
        when Hash then render(rendering.blank_slate_handler)
        end
      else
        content_tag :div, 'No records found'
      end
    end

    def actions_template(rendering)
      render(partial: 'mighty_grid/actions')
    end

    private

    def header_grid_html(rendering, grid, options)
      header_tr_html = MightyGrid::MgHTML.join_html_classes(options[:header_tr_html], MightyGrid.config.header_tr_class)

      content_tag :thead do
        content_tag :tr, header_tr_html do
          rendering.columns.map do |column|
            content_tag(:th, column.th_attrs) { grid_title_html(grid, column, options) }
          end.join.html_safe
        end
      end
    end

    def grid_title_html(grid, column, options)
      if column.options[:ordering] && column.attribute.present?
        order_asc = column.options[:order_asc] || options[:order_asc]
        order_desc = column.options[:order_desc] || options[:order_desc]
        order_active = grid.get_active_order_direction(grid_order_params(grid, column))

        case options[:order_type]
        when 'pair'
          order_asc_class = MightyGrid::MgHTML.join_html_classes({}, (order_active == 'asc' ? options[:order_active_link_class] : nil), options[:order_asc_link_class])[:class]
          order_desc_class = MightyGrid::MgHTML.join_html_classes({}, (order_active == 'desc' ? options[:order_active_link_class] : nil), options[:order_desc_link_class])[:class]
          html_title = column.title
          html_title += content_tag :div, class: options[:order_wrapper_class] do
            html_order = get_order_html(grid, column, order_active, order_asc, 'asc', class: order_asc_class)
            html_order += ' '
            html_order += get_order_html(grid, column, order_active, order_desc, 'desc', class: order_desc_class)
            html_order.html_safe
          end
        else
          html_title = link_to(column.title.html_safe, "?#{grid_order_params(grid, column).to_query}")
        end
        html_title.html_safe
      else
        column.title.html_safe
      end
    end

    def get_order_html(grid, column, order_active, order_html, direction = nil, html_options = {})
      if order_active == direction
        html = content_tag :span, order_html.html_safe, html_options
      else
        html = link_to(order_html.html_safe, "?#{grid_order_params(grid, column, direction).to_query}", html_options)
      end
      html.html_safe
    end

    def grid_order_params(grid, column, direction = nil)
      MightyGrid::MgHash.rec_merge(grid.params, grid.order_params(column.attribute, column.model, direction)).except('controller', 'action')
    end

    def body_grid_html(rendering, grid)
      content_tag :tbody do
        html_record = ''
        grid.relation.each do |rel|
          html_record += content_tag :tr do
            rendering.columns.map { |column| content_tag :td, column.render(rel), column.attrs }.join.html_safe
          end
        end
        html_record.html_safe
      end
    end

    def footer_grid_html(rendering, grid)
      content_tag :tfoot do
        content_tag :tr do
          content_tag :td, colspan: rendering.total_columns do
            html_pag = paginate(grid.relation, theme: MightyGrid.config.pagination_theme, param_name: "#{grid.name}[page]")
            html_pag += content_tag :strong do
              "#{grid.relation.offset_value + 1} &ndash; #{grid.relation.offset_value + grid.relation.size} of #{grid.relation.total_count}".html_safe
            end
            html_pag.html_safe
          end
        end.html_safe
      end
    end
  end
end
