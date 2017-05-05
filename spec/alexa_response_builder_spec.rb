require 'alexa/response_builder'

RSpec.describe Alexa::ResponseBuilder do
  let(:response_class)       { double(:"Alexa::Response", hash: {}) }
  let(:output_speech_class)  { double(:"Alexa::OutputSpeech") }

  describe '.build' do
    it 'constructs an OutputSpeech object using relevant options' do
      response_text = "Hello World"
      expect(output_speech_class).to receive(:new).with(speech: response_text)

      Alexa::ResponseBuilder.build(response_class, output_speech_class, response_text: response_text)
    end

    it 'constructs an OutputSpeech object using SSML' do
      response_text = "Hello World"
      expect(output_speech_class).to receive(:new).with(speech: response_text, ssml: true)

      Alexa::ResponseBuilder.build(response_class, output_speech_class, response_text: response_text, ssml: true)
    end

    it 'constructs the rest of the Response' do
      output_speech = double
      allow(output_speech_class).to receive(:new).and_return output_speech

      expect(response_class).to receive(:hash).with(output_speech: output_speech)

      Alexa::ResponseBuilder.build(response_class, output_speech_class)
    end
  end
end