require 'ralyxa/output_speech'

RSpec.describe Ralyxa::OutputSpeech do
  describe 'building a speech component of a response' do
    it 'defaults to plain text and "Hello World"' do
      expected_output_speech = {
        type: "PlainText",
        text: "Hello World"
      }

      expect(Ralyxa::OutputSpeech.as_hash).to eq expected_output_speech
    end

    it 'outputs a custom string if given' do
      expected_output_speech = {
        type: "PlainText",
        text: "Custom Text"
      }

      expect(Ralyxa::OutputSpeech.as_hash(speech: "Custom Text")).to eq expected_output_speech
    end

    it 'outputs SSML if given' do
      expected_output_speech = {
        type: "SSML",
        ssml: "<speak>Hello World</speak>"
      }

      expect(Ralyxa::OutputSpeech.as_hash(speech: "<speak>Hello World</speak>", ssml: true)).to eq expected_output_speech
    end

    it 'outputs default SSML if no string is given but SSML is required' do
      expected_output_speech = {
        type: "SSML",
        ssml: "<speak>Hello World</speak>"
      }

      expect(Ralyxa::OutputSpeech.as_hash(ssml: true)).to eq expected_output_speech
    end

    it 'does not limits the speech' do
      long_string = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque interdum rutrum sodales. Nullam mattis fermentum libero, noon volutpat."

      expect(Ralyxa::OutputSpeech.as_hash(speech: long_string)[:text]).to eq long_string
    end
  end
end