require_relative './output_speech'

module Ralyxa
  module ResponseEntities
    class Response
      def initialize(output_speech, session_attributes, end_session, start_over, card)
        @output_speech      = output_speech
        @session_attributes = session_attributes
        @end_session        = end_session
        @start_over         = start_over
        @card               = card
      end

      def to_h
        {}.tap do |response|
          add_version(response)
          add_session_attributes(response)
          add_response(response)
        end
      end

      def self.as_hash(output_speech: Ralyxa::OutputSpeech.as_hash, session_attributes: {}, end_session: false, start_over: false, card: false)
        new(output_speech, session_attributes, end_session, start_over, card).to_h
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
        response[:response] = {}
        response[:response][:outputSpeech] = @output_speech
        response[:response][:card] = @card if @card
        response[:response][:shouldEndSession] = @end_session
      end
    end
  end
end
