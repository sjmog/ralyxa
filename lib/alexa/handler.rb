require_relative './response'

module Alexa
  class Handler
    def initialize(response_class = Alexa::Response, output_speech_class = Alexa::OutputSpeech, &intent_proc)
      @response_class      = response_class
      @output_speech_class = output_speech_class
      @intent_proc         = intent_proc
    end

    def handle
      instance_eval &@intent_proc
    end

    def respond(response_text, response_details = {})
      output_speech_params = { speech: response_text }
      output_speech_params.merge!(ssml: true) if response_details.delete(:ssml)

      output_speech = @output_speech_class.new(output_speech_params)

      @response_class.build(response_details.merge(output_speech: output_speech))
    end

    def tell(response_text, response_details = {})
      respond(response_text, response_details.merge(end_session: true))
    end

    alias ask respond

    private :respond, :tell, :ask
  end
end