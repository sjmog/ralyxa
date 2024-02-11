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

    %w( respond tell ).each do |method_name|
      define_method method_name do |response_text = '', response_details = {}, response_builder = Ralyxa::ResponseBuilder|
        options = response_details
        options[:response_text] = response_text if response_text
        options.merge(end_session: true)        if method_name.eql?("tell")

        # method that avoids ArgumentError caused by positional and keyword argument separation differences between Ruby 2 and 3
        # see /lib/ralyxa/ruby_version_manager.rb
        manage_ruby_version_for(response_builder, method: :build, data: options)
      end
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
