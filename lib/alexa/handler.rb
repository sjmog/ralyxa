require_relative './response'

module Alexa
  class Handler
    def initialize(response_class = Alexa::Response, &intent_proc)
      @response_class = response_class
      @intent_proc    = intent_proc
    end

    def handle
      instance_eval &@intent_proc
    end

    def respond(response_text, response_details = {})
      @response_class.build(response_details.merge(response_text: response_text))
    end

    def tell(response_text, response_details = {})
      respond(response_text, response_details.merge(end_session: true))
    end

    alias ask respond

    private :respond, :tell, :ask
  end
end