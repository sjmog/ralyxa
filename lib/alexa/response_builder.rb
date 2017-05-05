require 'json'
require_relative './response'
require_relative './output_speech'

module Alexa
  class ResponseBuilder
    def initialize(response_class, output_speech_class, options)
      @response_class      = response_class
      @output_speech_class = output_speech_class
      @options             = options
    end

    def self.build(response_class = Alexa::Response, output_speech_class = Alexa::OutputSpeech, options = {})
      new(response_class, output_speech_class, options).build
    end

    def build
      @options.merge!(output_speech: output_speech)
      @response_class.hash(@options).to_json
    end

    private

    def output_speech
      output_speech_params = { speech: @options.delete(:response_text) }
      output_speech_params.merge!(ssml: @options.delete(:ssml)) if @options[:ssml]
      @output_speech_class.new(output_speech_params)
    end
  end
end