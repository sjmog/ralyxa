require_relative './output_speech'
require_relative './directives'

module Ralyxa
  module ResponseEntities
    class Response
      def initialize(output_speech, session_attributes, end_session, start_over, card, directives)
        @output_speech      = output_speech
        @session_attributes = session_attributes
        @end_session        = end_session
        @start_over         = start_over
        @card               = card
        @directives         = directives
      end

      def to_h
        {}.tap do |response|
          add_version(response)
          add_session_attributes(response)
          add_response(response)
        end
      end

      def self.as_hash(output_speech: false, session_attributes: {}, end_session: false, start_over: false, card: false, directives: false)
        new(output_speech, session_attributes, end_session, start_over, card, directives).to_h
      end

      private

      attr_reader :response

      def add_version(response)
        response[:version] = '1.0'
      end

      def add_session_attributes(response)
        return response[:sessionAttributes] = {} if @start_over
        response[:sessionAttributes] = @session_attributes unless @session_attributes.empty?
      end

      def add_response(response)
        response[:response] = {}.tap do |response_object|
          response_object[:outputSpeech]     = @output_speech if @output_speech
          response_object[:card]             = @card          if @card
          response_object[:directives]       = @directives    if @directives
          response_object[:shouldEndSession] = @end_session
        end
      end
    end
  end
end
