module Ralyxa
  class OutputSpeech
    DEFAULT_RESPONSE_TEXT = "Hello World"
    DEFAULT_RESPONSE_SSML = "<speak>Hello World</speak>"

    def initialize(speech, ssml)
      @speech = speech
      @ssml   = ssml
    end

    def to_h
      Hash.new.tap do |output_speech|
        @ssml ? set_ssml(output_speech) : set_plaintext(output_speech)
      end
    end

    def self.as_hash(speech: nil, ssml: false)
      new(speech, ssml).to_h
    end

    private

    def set_ssml(output_speech)
      output_speech[:type] = "SSML"
      output_speech[:ssml] = (@speech || DEFAULT_RESPONSE_SSML).slice(0, 140)
    end

    def set_plaintext(output_speech)
      output_speech[:type] = "PlainText"
      output_speech[:text] = (@speech || DEFAULT_RESPONSE_TEXT).slice(0, 140)
    end
  end
end