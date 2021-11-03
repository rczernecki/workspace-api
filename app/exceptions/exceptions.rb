module Exceptions
  class ValidationError < StandardError
    attr_accessor :errors

    def initialize(errors)
      @errors = errors
    end
  end
end
