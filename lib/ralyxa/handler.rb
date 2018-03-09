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
      options = response_details
      options[:response_text] = response_text if response_text

      response_builder.build(options)
    end

    def tell(response_text = '', response_details = {})
      respond(response_text, response_details.merge(end_session: true))
    end

    def card(title, body, image_url = nil, card_class = Ralyxa::ResponseEntities::Card)
      card_class.as_hash(title, body, image_url)
    end

    def audio_player
      Ralyxa::ResponseEntities::Directives::AudioPlayer
    end

    def link_account_card(card_class = Ralyxa::ResponseEntities::Card)
      card_class.link_account
    end

    def log(level, message)
      puts "[#{Time.new}] [#{@request.user_id}] #{level} - #{message}"
    end

    alias ask respond

    attr_reader :request
    private :request, :respond, :tell, :ask
  end
end
