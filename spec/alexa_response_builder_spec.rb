require 'alexa/response_builder'

RSpec.describe Alexa::ResponseBuilder do
  let(:response_class)       { double(:"Alexa::Response", hash: {}) }
  let(:output_speech)        { double(:alexa_output_speech) }
  let(:output_speech_class)  { double(:"Alexa::OutputSpeech", new: output_speech) }

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

    it 'constructs a Card object' do
      card = double(:alexa_card, to_h: {})

      expect(card).to receive(:to_h)

      Alexa::ResponseBuilder.build(response_class, output_speech_class, card: card)
    end

    it 'plugs the OutputSpeech hash into the Response' do
      expect(response_class).to receive(:hash).with(output_speech: output_speech)

      Alexa::ResponseBuilder.build(response_class, output_speech_class)
    end

    it 'plugs a Card hash into the Response' do
      card = double(:alexa_card, to_h: {})

      expect(response_class).to receive(:hash).with(output_speech: output_speech, card: card.to_h)

      Alexa::ResponseBuilder.build(response_class, output_speech_class, card: card)
    end
  end
end