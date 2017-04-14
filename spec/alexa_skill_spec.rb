require 'alexa/skill'

RSpec.describe Alexa::Skill do
  describe '.intents' do
    it 'starts with zero registered intents' do
      expect(described_class.registered_intents.length).to be_zero
    end
  end

  describe '.intent' do
    it 'registers an intent, referencing a given Proc' do
      intent_name = "IntentName"
      intent_proc = Proc.new {}

      described_class.intent(intent_name, &intent_proc)

      expect(described_class.registered_intents[intent_name]).to eq intent_proc
    end
  end

  describe '.handle' do
    it 'builds an Alexa Request and handles it' do
      request = double(:request, body: StringIO.new("{}"))
      alexa_request_wrapper = double(:"Alexa::Request")

      expect(described_class).to receive_message_chain(:new, :handle)
      expect(alexa_request_wrapper).to receive(:new).with(request)

      described_class.handle(request, alexa_request_wrapper)
    end
  end

  describe '#handle' do
    it 'delegates evaluation of an intent proc to a handler' do
      handler       = double(:"Alexa::Handler")
      intent_name   = "IntentName"
      intent_proc   = Proc.new {}
      described_class.class_variable_set(:@@intents, { "#{intent_name}" => intent_proc })
      alexa_request = double(:alexa_request, intent_name: intent_name)

      expect(handler).to receive(:handle).with(intent_proc)

      described_class.new(alexa_request).handle(handler)
    end
  end
end