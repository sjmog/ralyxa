require_relative './output_speech'

module Alexa
  class Response
    def initialize(output_speech, session_attributes, end_session, start_over)
      @output_speech      = output_speech
      @session_attributes = session_attributes
      @end_session        = end_session
      @start_over         = start_over
    end

    def to_h
      {}.tap do |response|
        set_version(response)
        set_session_attributes(response)
        set_response(response)
      end
    end

    def self.hash(output_speech: Alexa::OutputSpeech.new, session_attributes: {}, end_session: false, start_over: false)
      new(output_speech, session_attributes, end_session, start_over).to_h
    end

    private
    attr_reader :response

    def set_version(response)
      response[:version] = "1.0"
    end

    def set_session_attributes(response)
      return response[:sessionAttributes] = {} if @start_over
      response[:sessionAttributes] = @session_attributes unless @session_attributes.empty?
    end

    def set_response(response)
      response[:response] = Hash.new
      response[:response][:outputSpeech] = @output_speech
      response[:response][:shouldEndSession] = @end_session if @end_session
    end
  end
end