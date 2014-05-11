module MightyGrid
  module GridViewHelper
    def grid(grid, opts={}, &block)
      define_grid(grid, opts, &block)
      render_grid(grid)
    end

    def define_grid(grid, options={}, &block)

      rendering = GridRenderer.new(grid, self)

      block.call(rendering)

      table_html_attrs = options[:html] || {}
      table_html_attrs = MightyGrid::MgHTML.join_html_classes(table_html_attrs, 'mighty-grid', MightyGrid.config.table_class)

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

    def mighty_filter_for(grid, options={}, &block)
      html_options = options[:html] ||= {}
      html_options = MightyGrid::MgHTML.join_html_classes(html_options, 'mighty-grid-filter')
      html_options[:method] = options.delete(:method) if options.has_key?(:method)
      html_options[:method] ||= :get

      filter = FilterRenderer.new(grid, self)

      output = capture(filter, &block)
      form_tag(options[:url] || {}, html_options){ output }
    end

    def header_grid_html(rendering, grid, options)
      header_tr_html = options[:header_tr_html] || {}
      header_tr_html = MightyGrid::MgHTML.join_html_classes(header_tr_html, MightyGrid.config.header_tr_class)

      content_tag :thead do
        content_tag :tr, header_tr_html do
          rendering.columns.map { |column|
            content_tag :th, column.th_attrs do
              if column.options[:ordering]
                link_to(column.title, "?#{MightyGrid::MgHash.rec_merge(grid.params, {grid.name => {order: column.attribute, order_direction: grid.order_direction}}).except('controller', 'action').to_query}").html_safe
              else
                column.title.html_safe
              end
            end
          }.join.html_safe
        end
      end
    end

    def body_grid_html(rendering, grid)
      content_tag :tbody do
        html_record = ''
        grid.relation.each do |rel|
          html_record += content_tag :tr do
            rendering.columns.map{|column| content_tag :td, column.render(rel), column.attrs}.join.html_safe
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

    def blank_slate_template(rendering)
      if rendering.blank_slate_handler.present?
        case rendering.blank_slate_handler
        when Proc; return rendering.blank_slate_handler.call
        when String; return rendering.blank_slate_handler
        when Hash; return render(rendering.blank_slate_handler)
        end
      else
        content_tag :div, 'No records found'
      end
    end

  end
end