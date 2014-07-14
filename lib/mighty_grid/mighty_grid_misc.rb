module MightyGrid
  module ExceptionsMixin  #:nodoc:
    def initialize(str)  #:nodoc:
      super("MightyGrid: " + str)
    end
  end

  class MightyGridArgumentError < ArgumentError #:nodoc:
    include ExceptionsMixin
  end
end
