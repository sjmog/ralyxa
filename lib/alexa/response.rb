require 'json'

module Alexa
  class Response < Hash
    def initialize(response_text, session_attributes, end_session)
      @response_text = response_text
      @session_attributes = session_attributes
      @end_session = end_session

      set_version
      set_session_attributes
      set_response
    end

    def self.build(response_text: "Hello World", session_attributes: {}, end_session: false)
      new(response_text, session_attributes, end_session).to_json
    end

    private

    def set_version
      self[:version] = "1.0"
    end

    def set_session_attributes
      self[:sessionAttributes] = @session_attributes unless @session_attributes.empty?
    end

    def set_response
      self[:response] = Hash.new
      self[:response][:outputSpeech] = Hash.new
      self[:response][:outputSpeech][:type] = "PlainText"
      self[:response][:outputSpeech][:text] = @response_text
      self[:response][:shouldEndSession] = @end_session if @end_session
    end
  end
end