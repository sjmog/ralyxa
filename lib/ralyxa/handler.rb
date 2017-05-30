require_relative './response_builder'
require_relative './card'

module Ralyxa
  class Handler
    def initialize(request, intent_proc)
      @request     = request
      @intent_proc = intent_proc
    end

    def handle
      instance_eval &@intent_proc
    end

    def respond(response_text, response_details = {}, response_builder = Ralyxa::ResponseBuilder)
      response_builder.build(response_details.merge(response_text: response_text))
    end

    def tell(response_text, response_details = {})
      respond(response_text, response_details.merge(end_session: true))
    end

    def card(title, body, image_url = nil, card_class = Ralyxa::Card)
      card_class.as_hash(title, body, image_url)
    end

    def link_account_card(card_class = Ralyxa::Card)
      card_class.link_account
    end

    alias ask respond

    attr_reader :request
    private :request, :respond, :tell, :ask
  end
end