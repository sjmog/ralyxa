require 'ralyxa/response_entities/reprompt'

RSpec.describe Ralyxa::ResponseEntities::Reprompt do
  describe 'building a reprompt component of a response' do
    it 'defaults to plain text and "Hello World"' do
      expected_reprompt = {
        outputSpeech: {
          type: "PlainText",
          text: "Hello World"
        }
      }

      expect(Ralyxa::ResponseEntities::Reprompt.as_hash).to eq expected_reprompt
    end

    it 'outputs a custom string if given' do
      expected_reprompt = {
        outputSpeech: {
          type: "PlainText",
          text: "Custom Text"
        }
      }

      expect(Ralyxa::ResponseEntities::Reprompt.as_hash(reprompt_speech: "Custom Text")).to eq expected_reprompt
    end

    it 'outputs SSML if given' do
      expected_reprompt = {
        outputSpeech: {
          type: "SSML",
          ssml: "<speak>Hello World</speak>"
        }
      }

      expect(Ralyxa::ResponseEntities::Reprompt.as_hash(reprompt_speech: "<speak>Hello World</speak>", reprompt_ssml: true)).to eq expected_reprompt
    end

    it 'outputs default SSML if no string is given but SSML is required' do
      expected_reprompt = {
        outputSpeech: {
          type: "SSML",
          ssml: "<speak>Hello World</speak>"
        }
      }

      expect(Ralyxa::ResponseEntities::Reprompt.as_hash(reprompt_ssml: true)).to eq expected_reprompt
    end

    it 'does not limits the speech' do
      long_string = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque interdum rutrum sodales. Nullam mattis fermentum libero, noon volutpat."

      expect(Ralyxa::ResponseEntities::Reprompt.as_hash(reprompt_speech: long_string)[:outputSpeech][:text]).to eq long_string
    end
  end
end
