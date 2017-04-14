module Alexa
  class Handler
    def initialize(&intent_proc)
      @intent_proc = intent_proc
    end

    def handle
      instance_eval &@intent_proc
    end

    def respond(response_text, response_details = {})
      Alexa::Response.build(response_details.merge(response_text: response_text))
    end

    def tell(response_text, response_details = {})
      respond(response_text, response_details.merge(end_session: true))
    end

    alias ask respond

    private :respond, :tell, :ask
  end
end