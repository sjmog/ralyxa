require 'json'
require_relative './response_entities/response'

module Ralyxa
  class ResponseBuilder
    def initialize(response_class, output_speech_class, options)
      @response_class      = response_class
      @output_speech_class = output_speech_class
      @options             = options
    end

    def self.build(options = {}, response_class = Ralyxa::ResponseEntities::Response, output_speech_class = Ralyxa::ResponseEntities::OutputSpeech)
      new(response_class, output_speech_class, options).build
    end

    def build(options = nil)
      @option = options if options # allow class inject to be done in handler
      merge_output_speech
      merge_card if card_exists?
      merge_directive if @options[:dialog_type]

      @response_class.as_hash(@options).to_json
    end

    private

    def merge_output_speech
      @options.merge!(output_speech: output_speech) if @output_speech_class
    end

    def merge_card
      @options[:card] = @options[:card].to_h
    end

    def card_exists?
      @options[:card]
    end

    def output_speech
      output_speech_params = { speech: @options.delete(:response_text) }
      output_speech_params[:ssml] = @options.delete(:ssml) if @options[:ssml]

      @output_speech_class.as_hash(output_speech_params)
    end
  end
end
