module MightyGrid
  module Exceptions  #:nodoc:
    class ArgumentError < ::ArgumentError #:nodoc:
      def initialize(str)  #:nodoc:
        super("MightyGrid: #{str}")
      end
    end
  end
end
