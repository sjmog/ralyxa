require 'ralyxa/handler'

RSpec.describe Ralyxa::Handler do
  let(:intent)      { double(:intent) }
  let(:request)     { double(:request, intent: intent) }
  let(:intent_proc) { Proc.new { |object| object } }
  subject(:handler) { described_class.new(request) }

  describe '#handle' do
    it 'is initially undefined' do
      expect { handler.handle }.to raise_error NotImplementedError
    end
  end

  context 'convenient intent declaration interfaces' do
    describe '#respond' do
      it 'provides a more convenient interface for constructing responses in intent declarations' do
        response_builder = double(:"Ralyxa::ResponseBuilder")

        expect(response_builder).to receive(:build).with(response_text: "Hello World")

        handler.send(:respond, "Hello World", {}, response_builder)
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

    describe '#card' do
      it 'constructs a card' do
        card_class = double(:"Ralyxa::Card")

        expect(card_class).to receive(:as_hash).with("Title", "Body", "https://image.url")

        handler.send(:card, "Title", "Body", "https://image.url", card_class)
      end
    end

    describe '#link_account_card' do
      it 'constructs an Account Linking card' do
        card_class = double(:"Ralyxa::Card")

        expect(card_class).to receive(:link_account)

        handler.send(:link_account_card, card_class)
      end
    end
  end

  describe 'dialog' do
    context 'delegate' do
      it 'just sends the dialog.delegate method back as response with all intent field populated' do
        dialog_delegate_hash = {
          type: "Dialog.Delegate",
          updatedIntent: request.intent
        }

        expect(handler).to receive(:respond).with('', dialog_delegate_hash)

        handler.send(:dialog_delegate)
      end
    end
  end
end
