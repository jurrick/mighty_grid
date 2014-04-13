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
      header_tr_html = options[:header_tr_html] || {}

      grid.output_buffer = content_tag :table, table_html_attrs do
        html = content_tag :thead do
          content_tag :tr, header_tr_html do
            rendering.th_columns.map{|column| content_tag :th, column[:title], column[:html]}.join.html_safe
          end
        end

        html += content_tag :tbody do
          html_record = ''
          grid.relation.each do |rel|
            html_record += content_tag :tr do
              rendering.columns.map{|column| content_tag :td, column.render(rel), column.attrs}.join.html_safe
            end
          end
          html_record.html_safe
        end

        html
      end

    end

    def render_grid(grid)
      grid.output_buffer.html_safe
    end
  end
end