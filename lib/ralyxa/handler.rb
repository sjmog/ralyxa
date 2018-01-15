require_relative './response_builder'
require_relative './response_entities/card'

# Handler Base Class. Each Intent Handler inherits from this, and overwrites the #handle method.
module Ralyxa
  class Handler
    def initialize(request)
      @request = request
    end

    def handle
      raise NotImplementedError
    end

    def respond(response_text = '', response_details = {}, response_builder = Ralyxa::ResponseBuilder)
      response_builder.build(response_details.merge(response_text: response_text))
    end

    def tell(response_text = '', response_details = {})
      respond(response_text, response_details.merge(end_session: true))
    end

    def card(title, body, image_url = nil, card_class = Ralyxa::ResponseEntities::Card)
      card_class.as_hash(title, body, image_url)
    end

    def link_account_card(card_class = Ralyxa::ResponseEntities::Card)
      card_class.link_account
    end

    def dialog_delegate(response_text = nil)
      response = if response_text
          {
            outputSpeech: {
              type: "PlainText",
              text: response_text
            }
          }
        else
          {}
        end

      {
        version: "1.0",
        sessionAttributes: {},
        response: response.merge(

          shouldEndSession: false,
          directives: [
            {
              type: "Dialog.Delegate",
            }
          ]
        )
      }.to_json
    end

    def dialog_elicit(response_text, slot)
      {
        version: "1.0",
        sessionAttributes: {},
        response: {
          outputSpeech: {
            type: "PlainText",
            text: response_text
          },
          shouldEndSession: false,
          directives: [
            {
              type: "Dialog.ElicitSlot",
              slotToElicit: slot
            }
          ]
        }
      }.to_json
    end

    alias ask respond

    attr_reader :request
    private :request, :respond, :tell, :ask
  end
end
