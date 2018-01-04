require_relative './request_entities/request'
require_relative './handler'

# Routes an incoming request to the correct Handler.
module Ralyxa
  class Skill
    @handlers = {}

    def initialize(request)
      @request = request
    end

    def handle
      handler = self.class.handlers[@request.intent_name]
      handler ? handler.new(@request).handle : warn(handler_not_found)
    end

    class << self
      def intent(intent_name, handler_base_class = Ralyxa::Handler, &intent_block)
        intent_handler = Class.new(handler_base_class)
        intent_handler.send(:define_method, :handle, &intent_block)
        @handlers[intent_name] = intent_handler
      end

      def handle(request, alexa_request_wrapper = Ralyxa::RequestEntities::Request)
        new(alexa_request_wrapper.new(request)).handle
      end

      def handlers
        @handlers.dup
      end
    end

    private

    def handler_not_found
      <<~HEREDOC
        \e[33m
        WARNING: An intent declaration for intent "#{@request.intent_name}" was not found.

        To define it, add an intent declaration inside a directory called 'intents',
        on the same directory level as the runfile for your server application.

        You probably want something like:

        intent "#{@request.intent_name}" do
          respond("Hello World!")
        end
        \e[0m
      HEREDOC
    end
  end
end
