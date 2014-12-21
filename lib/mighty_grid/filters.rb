require 'active_support/core_ext/class/attribute'
require 'mighty_grid/map_type'

module MightyGrid
  module Filters
    extend ActiveSupport::Autoload

    autoload :Base
    autoload :StringFilter
    autoload :TextFilter
    autoload :EnumFilter
    autoload :BooleanFilter

    def self.included(base)
      base.class_eval do
        class_attribute :filters
        self.filters = {}

        extend MapType
        map_type :string, to: MightyGrid::Filters::StringFilter
        map_type :text, to: MightyGrid::Filters::TextFilter
        map_type :enum, to: MightyGrid::Filters::EnumFilter
        map_type :boolean, to: MightyGrid::Filters::BooleanFilter
      end

      base.send :extend, ClassMethods
      base.send :include, InstanceMethods
    end

    module InstanceMethods
      # Get filter parameter name
      def filter_param_name
        'f'
      end

      # Get filter parameters
      def filter_params
        @mg_params[filter_param_name.to_sym] || {}
      end

      # Add param to filters
      def add_filter_param(param, value)
        @mg_params[filter_param_name.to_sym][param] = value unless @mg_params[filter_param_name.to_sym].key?(param)
      end

      # Get filter name by field
      def get_filter_name(field, model = nil)
        field_name = model.present? ? "#{model.table_name}.#{field}" : field
        "#{name}[#{filter_param_name}][#{field_name}]"
      end

      # Apply filters
      def apply_filters
        @filters.each_pair do |filter_name, filter|
          next if filter_params[filter_name.to_s].blank?

          filter_value = filter_params[filter_name.to_s]

          table_name = filter.options[:model].table_name

          case filter
          when EnumFilter
            @relation = @relation.where(table_name => { filter.attribute => filter_value })
          when BooleanFilter
            value = %w(true 1 t).include?(filter_value) ? true : false
            @relation = @relation.where(table_name => { filter.attribute => value })
          when StringFilter, TextFilter
            @relation = @relation.where("#{table_name}.#{filter.attribute} #{like_operator} ?", "%#{filter_value}%")
          end
        end
      end
    end

    module ClassMethods
      def filter(name, type = :string, options = {})
        name = name.to_sym

        unless self.mappings.key?(type)
          fail MightyGrid::Exceptions::ArgumentError.new("filter for the specified type isn't supported.")
        end

        if name.present? && self.filters.key?(name)
          fail MightyGrid::Exceptions::ArgumentError.new("filter with the specified name already exists.")
        else
          options.merge!(name: name)
          options.merge!(model: @klass) unless options.key?(:model)
          self.filters[name] = self.mappings[type].new(options)
        end
      end

      protected

      def inherited(child_class)
        super(child_class)
        child_class.filters = self.filters.clone
      end
    end
  end
end
