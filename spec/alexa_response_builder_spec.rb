require 'alexa/response_builder'

RSpec.describe Alexa::ResponseBuilder do
  let(:response_class)       { double(:"Alexa::Response", as_hash: {}) }
  let(:output_speech)        { double(:alexa_output_speech) }
  let(:output_speech_class)  { double(:"Alexa::OutputSpeech", as_hash: output_speech) }

  describe '.build' do
    it 'constructs an OutputSpeech object using relevant options' do
      response_text = "Hello World"
      expect(output_speech_class).to receive(:as_hash).with(speech: response_text)

      Alexa::ResponseBuilder.build({ response_text: response_text }, response_class, output_speech_class)
    end

    it 'constructs an OutputSpeech object using SSML' do
      response_text = "Hello World"
      expect(output_speech_class).to receive(:as_hash).with(speech: response_text, ssml: true)

      Alexa::ResponseBuilder.build({ response_text: response_text , ssml: true }, response_class, output_speech_class)
    end

    it 'constructs a Card object' do
      card = double(:alexa_card, to_h: {})

      expect(card).to receive(:to_h)

      Alexa::ResponseBuilder.build({ card: card }, response_class, output_speech_class)
    end

    it 'plugs the OutputSpeech hash into the Response' do
      expect(response_class).to receive(:as_hash).with(output_speech: output_speech)

      Alexa::ResponseBuilder.build({}, response_class, output_speech_class)
    end

    it 'plugs a Card hash into the Response' do
      card = double(:alexa_card, to_h: {})

      expect(response_class).to receive(:as_hash).with(output_speech: output_speech, card: card.to_h)

      Alexa::ResponseBuilder.build({ card: card }, response_class, output_speech_class)
    end
  end
end