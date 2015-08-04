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
    autoload :CustomFilter
    autoload :SearchFilter

    def self.included(base)
      base.class_eval do
        class_attribute :filters
        class_attribute :query
        class_attribute :search_name
        self.filters = {}
        self.query = nil
        self.search_name = nil

        extend MapType
        map_type :string, to: MightyGrid::Filters::StringFilter
        map_type :text, to: MightyGrid::Filters::TextFilter
        map_type :enum, to: MightyGrid::Filters::EnumFilter
        map_type :boolean, to: MightyGrid::Filters::BooleanFilter
        map_type :custom, to: MightyGrid::Filters::CustomFilter
        map_type :search, to: MightyGrid::Filters::SearchFilter
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

      def get_search_name
        self.search_name
      end

      def get_filter_value(filter_name, filter)
        if filter_params.present?
          filter_params[filter_name.to_s]
        else
          filter.default.to_s
        end
      end

      # Apply filters
      def ar_apply_filters
        @filters.each_pair do |filter_name, filter|
          next if (filter_params.blank?   && filter.default.blank? ||
                   filter_params.present? && filter_params[filter_name.to_s].blank?)

          filter_value = get_filter_value(filter_name, filter)

          table_name = filter.model.table_name

          case filter
          when EnumFilter
            @relation = @relation.where(table_name => { filter.attribute => filter_value })
          when BooleanFilter
            value = %w(true 1 t).include?(filter_value) ? true : false
            @relation = @relation.where(table_name => { filter.attribute => value })
          when StringFilter, TextFilter
            @relation = @relation.where("#{table_name}.#{filter.attribute} #{like_operator} ?", "%#{filter_value}%")
          when CustomFilter
            if filter.scope.kind_of?(Proc)
              @relation = filter.scope.call(@relation, filter_value)
            else
              @relation = @relation.send(filter.scope, filter_value)
            end
          end
        end
      end

      # Thinking Sphinx apply filters
      def ts_apply_filters
        # TODO: Make filters for Thinking Sphinx
      end

      def search_apply_filter
        self.query = get_filter_value(self.search_name, @filters[self.search_name])
      end
    end

    module ClassMethods
      def filter(name, type = :string, options = {}, &block)
        name = name.to_sym

        unless self.mappings.key?(type)
          fail MightyGrid::Exceptions::ArgumentError.new("filter for the specified type isn't supported.")
        end

        if name.present? && self.filters.key?(name)
          fail MightyGrid::Exceptions::ArgumentError.new("filter with the specified name already exists.")
        else
          options.merge!(name: name)
          options.merge!(model: @klass) unless options.key?(:model)
          self.filters[name] = self.mappings[type].new(options, &block)
        end
      end

      def search(name)
        filter(name, :search)
        self.search_name = name
      end

      protected

      def inherited(child_class)
        super(child_class)
        child_class.filters = self.filters.clone
        child_class.query = self.query.try(:clone)
      end
    end
  end
end
