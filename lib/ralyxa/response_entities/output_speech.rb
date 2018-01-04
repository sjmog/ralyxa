module Ralyxa
  module ResponseEntities
    class OutputSpeech
      DEFAULT_RESPONSE_TEXT = 'Hello World'.freeze
      DEFAULT_RESPONSE_SSML = '<speak>Hello World</speak>'.freeze

      def initialize(speech, ssml)
        @speech = speech
        @ssml   = ssml
      end

      def to_h
        {}.tap do |output_speech|
          @ssml ? add_ssml(output_speech) : add_plaintext(output_speech)
        end
      end

      def self.as_hash(speech: nil, ssml: false)
        new(speech, ssml).to_h
      end

      private

      def add_ssml(output_speech)
        output_speech[:type] = 'SSML'
        output_speech[:ssml] = (@speech || DEFAULT_RESPONSE_SSML)
      end

      def add_plaintext(output_speech)
        output_speech[:type] = 'PlainText'
        output_speech[:text] = (@speech || DEFAULT_RESPONSE_TEXT)
      end
    end
  end
end
