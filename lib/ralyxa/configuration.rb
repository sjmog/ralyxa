module Ralyxa
  class Configuration
    attr_accessor :validate_requests, :require_secure_urls

    def initialize
      @validate_requests = true
      @require_secure_urls = true
    end

    def validate_requests?
      validate_requests
    end

    def require_secure_urls?
      require_secure_urls
    end
  end
end
