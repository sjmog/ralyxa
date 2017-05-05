require 'alexa/handler'

RSpec.describe Alexa::Handler do
  let(:response_builder) { double(:"Alexa::ResponseBuilder") }
  let(:intent_proc)      { Proc.new { self.class } }
  subject(:handler)      { described_class.new(response_builder, &intent_proc) }

  describe '#handle' do
    it 'executes an intent Proc bound to the scope of the current class' do
      expect(handler.handle).to eq described_class
    end
  end

  context 'convenient intent declaration interfaces' do
    describe '#respond' do
      it 'provides a more convenient interface for constructing responses in intent declarations' do
        response_text = "Hello World"
        expect(response_builder).to receive(:build).with(response_text, {})

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