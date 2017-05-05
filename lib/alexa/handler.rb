require_relative './response'
require_relative './card'

module Alexa
  class Handler
    def initialize(response_builder = Alexa::ResponseBuilder, card_class = Alexa::Card, &intent_proc)
      @response_builder = response_builder
      @card_class       = card_class
      @intent_proc      = intent_proc
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

    def card(title, body, image_url = nil)
      @card = @card_class.hash(title, body, image_url)
    end

    alias ask respond

    private :respond, :tell, :ask
  end
end