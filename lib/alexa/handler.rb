require_relative './response'

module Alexa
  class Handler
    def initialize(response_builder = Alexa::ResponseBuilder, &intent_proc)
      @response_builder    = response_builder
      @intent_proc         = intent_proc
    end

    def handle
      instance_eval &@intent_proc
    end

    def respond(response_text, response_details = {})
      @response_builder.build(response_text, response_details)
    end

    def tell(response_text, response_details = {})
      respond(response_text, response_details.merge(end_session: true))
    end

    alias ask respond

    private :respond, :tell, :ask
  end
end