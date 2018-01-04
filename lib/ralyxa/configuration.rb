module Ralyxa
  class Configuration
    attr_accessor :validate_requests

    def initialize
      @validate_requests = true
    end

    def validate_requests?
      validate_requests
    end
  end
end
