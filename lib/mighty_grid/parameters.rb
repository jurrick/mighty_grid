module MightyGrid
  module Parameters
    def self.included(base)
      base.include InstanceMethods
    end

    module InstanceMethods
      # Load grid parameters
      def load_grid_params
        @mg_params = {}
        @mg_params[filter_param_name.to_sym] = {}
        @mg_params.merge!(@options)
        if current_grid_params
          @mg_params.merge!(current_grid_params.symbolize_keys)
          if @mg_params[:order].present? && !@mg_params[:order].to_s.include?('.')
            @mg_params[:order] = "#{klass.table_name}.#{@mg_params[:order]}"
          end
        end
      end

      # Get current grid parameter by name
      def get_current_grid_param(name)
        current_grid_params.key?(name) ? current_grid_params[name] : nil
      end

      # Get current grid parameters
      def current_grid_params
        params[name] || {}
      end

      # Get order parameters
      def order_params(attribute, model = nil, direction = nil)
        order = model.present? ? "#{model.table_name}.#{attribute}" : attribute.to_s
        direction ||= order == current_grid_params['order'] ? another_order_direction : 'asc'
        { @name => { order: order, order_direction: direction } }
      end

      # Get current order direction if current order parameter coincides with the received parameter
      def get_active_order_direction(parameters)
        parameters[@name]['order'] == current_grid_params['order'] ? current_order_direction : nil
      end

      # Get current order direction
      def current_order_direction
        direction = nil
        if current_grid_params.key?('order_direction') && %w(asc desc).include?(current_grid_params['order_direction'].downcase)
          direction = current_grid_params['order_direction'].downcase
        end
        direction
      end

      # Get another order direction
      def another_order_direction
        current_grid_params.key?('order_direction') ? (%w(asc desc) - [current_grid_params['order_direction'].to_s]).first : MightyGrid.order_direction
      end
    end
  end
end
