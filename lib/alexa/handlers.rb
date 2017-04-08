require './lib/alexa/request'
require './lib/alexa/response'

module Alexa
  class Handlers
    @@intents = {}

    def initialize(request)
      @request = request
    end

    def handle
      instance_eval &registered_intent(request.intent_name)
    end

    class << self
      def intent(intent_name, &block)
        @@intents[intent_name] = block
      end

      def handle(request)
        new(Alexa::Request.new(request)).handle
      end
    end

    attr_reader :request

    def registered_intent(intent_name)
      @@intents[intent_name]
    end

    def respond(response_text, response_details = {})
      Alexa::Response.build(response_details.merge(response_text: response_text))
    end

    def tell(response_text, response_details = {})
      respond(response_text, response_details.merge(end_session: true))
    end

    alias ask respond

    private :request, :registered_intent, :respond, :tell
  end
end