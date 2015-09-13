module MightyGrid
  module Filters
    class CustomFilter < Base
      attr_reader :scope, :collection

      def initialize(options = {}, &block)
        self.class.default_options.merge!(scope: nil, collection: nil)

        super(options)
        
        @collection = @options[:collection]

        if block_given?
          @scope = block
        else
          @scope = @options.delete(:scope)
        end
      end
    end
  end
end
