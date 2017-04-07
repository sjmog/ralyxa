require 'json'

module Alexa
  class Response < Hash
    def initialize(response_text, session_attributes, end_session, start_over)
      @response_text      = response_text
      @session_attributes = session_attributes
      @end_session        = end_session
      @start_over         = start_over

      set_version
      set_session_attributes
      set_response
    end

    def self.build(response_text: "Hello World", session_attributes: {}, end_session: false, start_over: false)
      new(response_text, session_attributes, end_session, start_over).to_json
    end

    private

    def set_version
      self[:version] = "1.0"
    end

    def set_session_attributes
      return self[:sessionAttributes] = {} if @start_over
      self[:sessionAttributes] = @session_attributes unless @session_attributes.empty?
    end

    def set_response
      self[:response] = Hash.new
      self[:response][:outputSpeech] = Hash.new
      self[:response][:outputSpeech][:type] = "PlainText"
      self[:response][:outputSpeech][:text] = @response_text.slice(0, 140)
      self[:response][:shouldEndSession] = @end_session if @end_session
    end
  end
end