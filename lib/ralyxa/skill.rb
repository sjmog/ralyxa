require_relative './request'
require_relative './response'
require_relative './handler'

module Ralyxa
  class Skill
    @@intents = {}

    def initialize(request)
      @request = request
    end

    def handle(handler = Ralyxa::Handler)
      intent_proc = self.class.registered_intents[@request.intent_name]
      handler.new(@request, intent_proc).handle
    end

    class << self
      def intent(intent_name, &block)
        @@intents[intent_name] = block
      end

      def registered_intents
        @@intents.dup
      end

      def handle(request, alexa_request_wrapper = Ralyxa::Request)
        new(alexa_request_wrapper.new(request)).handle
      end
    end
  end
end