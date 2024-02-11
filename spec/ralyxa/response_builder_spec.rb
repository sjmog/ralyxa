require 'ralyxa/response_builder'

RSpec.describe Ralyxa::ResponseBuilder do
  let(:response_class)       { double(:"Ralyxa::Response", as_hash: {}) }
  let(:output_speech)        { double(:alexa_output_speech) }
  let(:output_speech_class)  { double(:"Ralyxa::OutputSpeech", as_hash: output_speech) }
  let(:reprompt)             { double(:alexa_reprompt) }
  let(:reprompt_class)       { double(:"Ralyxa::Reprompt", as_hash: reprompt) }

  describe '.build' do
    it 'constructs an OutputSpeech object using relevant options' do
      response_text = "Hello World"
      expect(output_speech_class).to receive(:as_hash).with(speech: response_text)

      Ralyxa::ResponseBuilder.build({ response_text: response_text }, response_class, output_speech_class)
    end

    it 'constructs an OutputSpeech object using SSML' do
      response_text = "Hello World"
      expect(output_speech_class).to receive(:as_hash).with(speech: response_text, ssml: true)

      Ralyxa::ResponseBuilder.build({ response_text: response_text , ssml: true }, response_class, output_speech_class)
    end

    it 'constructs a Card object' do
      card = double(:alexa_card, to_h: {})

      expect(card).to receive(:to_h)

      Ralyxa::ResponseBuilder.build({ card: card }, response_class, output_speech_class)
    end

    context 'with a response_text value' do
      it 'plugs the OutputSpeech hash into the Response ' do
        expect(response_class).to receive(:as_hash).with(output_speech: output_speech)

        Ralyxa::ResponseBuilder.build({response_text: ''}, response_class, output_speech_class)
      end
    end

    context 'without a response_text value' do
      it 'returns an empty hash' do
        expect(response_class).to receive(:as_hash)
        
        Ralyxa::ResponseBuilder.build({}, response_class, output_speech_class) 
      end
    end

    context 'with a reprompt object' do
      let(:reprompt)      { "Please say that again." }
      let(:response_text) { "Hello World" }

      it 'constructs a reprompt object using relevant options' do
        expect(reprompt_class).to receive(:as_hash).with(reprompt_speech: reprompt)

        Ralyxa::ResponseBuilder.build({ response_text: response_text, reprompt: reprompt }, response_class, output_speech_class, reprompt_class)
      end

      it 'constructs a repromp object using SSML' do
        expect(reprompt_class).to receive(:as_hash).with(reprompt_speech: reprompt, reprompt_ssml: true)

        Ralyxa::ResponseBuilder.build({ response_text: response_text, reprompt: reprompt, reprompt_ssml: true }, response_class, output_speech_class, reprompt_class)
      end
    end

    it 'plugs a Card hash into the Response' do
      card = double(:alexa_card, to_h: {})

      expect(response_class).to receive(:as_hash).with(card: card.to_h)

      Ralyxa::ResponseBuilder.build({ card: card }, response_class, output_speech_class)
    end
  end
end