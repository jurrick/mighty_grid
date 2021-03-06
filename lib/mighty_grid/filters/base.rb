module MightyGrid
  module Filters
    class Base
      attr_reader :options, :attribute, :model, :default
      attr_accessor :search_value

      class_attribute :default_options
      self.default_options = {
        name: nil,
        attribute: nil,
        model: nil,
        default: nil
      }


      def initialize(options = {})
        options = options.clone

        options.assert_valid_keys(self.class.default_options.keys)

        @options = options.reverse_merge!(self.class.default_options)
        @attribute = @options.delete(:attribute) || @options[:name]
        @model = @options.delete(:model)
        @default = @options.delete(:default)
      end
    end
  end
end
