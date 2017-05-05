require 'alexa/handler'

RSpec.describe Alexa::Handler do
  let(:response_class)      { double(:"Alexa::Response") }
  let(:output_speech)       { double(:alexa_output_speech) }
  let(:output_speech_class) { double(:"Alexa::OutputSpeech", new: output_speech) }
  let(:intent_proc)         { Proc.new { self.class } }
  subject(:handler)         { described_class.new(response_class, output_speech_class, &intent_proc) }

  describe '#handle' do
    it 'executes an intent Proc bound to the scope of the current class' do
      expect(handler.handle).to eq described_class
    end
  end

  context 'convenient intent declaration interfaces' do
    describe '#respond' do
      it 'provides a more convenient interface for constructing responses in intent declarations' do
        response_text = "Hello World"
        expect(output_speech_class).to receive(:new).with(speech: response_text)
        expect(response_class).to receive(:build).with(output_speech: output_speech)

        handler.send(:respond, "Hello World")
      end
    end

    describe '#ask' do
      it 'aliases #respond' do
        expect(handler.method(:ask)).to eq handler.method(:respond)
      end
    end

    describe '#tell' do
      it 'delegates to respond, and ends the session' do
        response_text = "Hello World"
        expect(handler).to receive(:respond).with(response_text, end_session: true)

        handler.send(:tell, "Hello World")
      end
    end
  end
end