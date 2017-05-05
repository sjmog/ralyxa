module Alexa
  class OutputSpeech < Hash
    DEFAULT_RESPONSE_TEXT = "Hello World"
    DEFAULT_RESPONSE_SSML = "<speak>Hello World</speak>"

    def initialize(speech: nil, ssml: false)
      if ssml
        self[:type] = "SSML"
        self[:ssml] = (speech || DEFAULT_RESPONSE_SSML).slice(0, 140)
      else
        self[:type] = "PlainText"
        self[:text] = (speech || DEFAULT_RESPONSE_TEXT).slice(0, 140)
      end
    end
  end
end