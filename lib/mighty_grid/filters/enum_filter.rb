module MightyGrid
  module Filters
    class EnumFilter < Base
      attr_reader :collection

      def initialize(options = {})
        self.class.default_options.merge!(collection: nil)

        super(options)

        @collection = @options[:collection]
      end
    end
  end
end
