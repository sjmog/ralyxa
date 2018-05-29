require 'json'
require_relative './response_entities/response'

module Ralyxa
  class ResponseBuilder
    def initialize(response_class, output_speech_class, reprompt_class, options)
      @response_class      = response_class
      @output_speech_class = output_speech_class
      @reprompt_class      = reprompt_class
      @options             = options
    end

    def self.build(options = {}, response_class = Ralyxa::ResponseEntities::Response, output_speech_class = Ralyxa::ResponseEntities::OutputSpeech, reprompt_class = Ralyxa::ResponseEntities::Reprompt)
      new(response_class, output_speech_class, reprompt_class, options).build
    end

    def build
      merge_output_speech if response_text_exists?
      merge_reprompt if reprompt_exists?
      merge_card if card_exists?

      @response_class.as_hash(@options).to_json
    end

    private

    def merge_output_speech
      @options.merge!(output_speech: output_speech)
    end

    def merge_reprompt
      @options.merge!(reprompt: reprompt)
    end

    def merge_card
      @options[:card] = @options[:card].to_h
    end

    def card_exists?
      @options[:card]
    end

    def response_text_exists?
      @options[:response_text]
    end

    def reprompt_exists?
      @options[:reprompt]
    end

    def output_speech
      output_speech_params = { speech: @options.delete(:response_text) }
      output_speech_params[:ssml] = @options.delete(:ssml) if @options[:ssml]

      @output_speech_class.as_hash(output_speech_params)
    end

    def reprompt
      reprompt_params = { reprompt_speech: @options.delete(:reprompt) }
      reprompt_params[:reprompt_ssml] = @options.delete(:reprompt_ssml) if @options[:reprompt_ssml]

      @reprompt_class.as_hash(reprompt_params)
    end
  end
end
