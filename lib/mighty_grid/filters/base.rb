module MightyGrid
  module Filters
    class Base
      attr_reader :options, :attribute

      class_attribute :default_options
      self.default_options = {
        name: nil,
        attribute: nil,
        model: nil,
        default: nil,
        by_scope: nil
      }


      def initialize(options = {})
        options = options.clone

        options.assert_valid_keys(self.class.default_options.keys)
        @options = options.reverse_merge!(self.class.default_options)
        @attribute = @options.delete(:attribute) || @options[:name]
      end
    end
  end
end
