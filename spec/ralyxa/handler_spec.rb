require 'ralyxa/handler'

RSpec.describe Ralyxa::Handler do
  let(:request)     { double(:request) }
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

        handler.send(:respond, 'Hello World', {}, response_builder)
      end
    end

    describe '#ask' do
      it 'aliases #respond' do
        expect(handler.method(:ask)).to eq handler.method(:respond)
      end
    end

    describe '#tell' do
      it 'ends the session' do
        response_builder = double(:"Ralyxa::ResponseBuilder")
        response_text    = "Hello World"
        expect(handler).to receive(:tell).with(response_text, end_session: true)

        handler.send(:tell, response_text, end_session: true)
      end
    end

    describe '#card' do
      it 'constructs a card' do
        card_class = double(:"Ralyxa::Card")

        expect(card_class).to receive(:as_hash).with("Title", "Body", "https://image.url")

        handler.send(:card, "Title", "Body", "https://image.url", card_class)
      end
    end

    describe '#audio_player' do
      it 'creates a new instance of Ralyxa::ResponseEndities::Directives::AudioPlayer' do
        expect(handler.audio_player).to eq(Ralyxa::ResponseEntities::Directives::AudioPlayer)
      end
    end

    describe '#link_account_card' do
      it 'constructs an Account Linking card' do
        card_class = double(:"Ralyxa::Card")

        expect(card_class).to receive(:link_account)

        handler.send(:link_account_card, card_class)
      end
    end

    describe '#log' do
      let(:time_local) { Time.local(2017, 01, 28, 00, 16, 04) }

      before :each do
        Timecop.freeze(time_local)

        @handler = handler
        @handler.instance_variable_set(:@request, double(:request, user_id: 'user-1'))
      end

      after :each do
        Timecop.return
      end

      it 'passes the expected information to puts' do
        expect(STDOUT).to receive(:puts).with("[#{time_local}] [user-1] TEST - This is a test message")

        handler.send(:log, 'TEST', 'This is a test message')
      end
    end
  end
end