module Ralyxa
  module ResponseEntities
    class Reprompt
      def initialize(reprompt_speech, reprompt_ssml)
        @reprompt_speech = reprompt_speech
        @reprompt_ssml   = reprompt_ssml
      end

      def to_h
        {}.tap do |reprompt|
          reprompt[:outputSpeech] = Ralyxa::ResponseEntities::OutputSpeech.as_hash(speech: @reprompt_speech, ssml: @reprompt_ssml)
        end
      end

      def self.as_hash(reprompt_speech: nil, reprompt_ssml: false)
        new(reprompt_speech, reprompt_ssml).to_h
      end
    end
  end
end
