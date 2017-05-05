require 'alexa/output_speech'

RSpec.describe Alexa::OutputSpeech do
  describe 'building a speech component of a response' do
    it 'defaults to plain text and "Hello World"' do
      expected_output_speech = {
        type: "PlainText",
        text: "Hello World"
      }

      expect(Alexa::OutputSpeech.hash).to eq expected_output_speech
    end

    it 'outputs a custom string if given' do
      expected_output_speech = {
        type: "PlainText",
        text: "Custom Text"
      }

      expect(Alexa::OutputSpeech.hash(speech: "Custom Text")).to eq expected_output_speech
    end

    it 'outputs SSML if given' do
      expected_output_speech = {
        type: "SSML",
        ssml: "<speak>Hello World</speak>"
      }

      expect(Alexa::OutputSpeech.hash(speech: "<speak>Hello World</speak>", ssml: true)).to eq expected_output_speech
    end

    it 'outputs default SSML if no string is given but SSML is required' do
      expected_output_speech = {
        type: "SSML",
        ssml: "<speak>Hello World</speak>"
      }

      expect(Alexa::OutputSpeech.hash(ssml: true)).to eq expected_output_speech
    end

    it 'limits the speech to 140 characters' do
      over_length_string = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque interdum rutrum sodales. Nullam mattis fermentum libero, noon volutpat."
      expect(over_length_string).to receive(:slice).with(0, 140)
      
      Alexa::OutputSpeech.hash(speech: over_length_string)
    end
  end
end