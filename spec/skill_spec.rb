require 'ralyxa/skill'

RSpec.describe Ralyxa::Skill do
  describe '.handlers' do
    it 'starts with zero registered handlers' do
      expect(described_class.handlers.length).to be_zero
    end
  end

  describe '.intent' do
    it 'defines a handler, which responds to #handle by executing a given Proc within its scope' do
      intent_name = "IntentName"
      handler_bass_class_double = Object
      intent_block = Proc.new { self.class }

      handler_class = described_class.intent(intent_name, handler_bass_class_double, &intent_block)

      expect(handler_class.new.handle).to eq handler_class
    end

    it 'handles early returns in those Procs' do
      early_return_proc = Proc.new { return "Early return!"; raise LocalJumpError }

      handler_class = described_class.intent("IntentName", Object, &early_return_proc)

      expect { handler_class.new.handle }.not_to raise_error LocalJumpError
    end

    it 'stores these handlers by IntentName in a dictionary' do
      intent_name = "IntentName"
      handler_bass_class_double = Object
      intent_block = Proc.new { self.class }

      handler_class = described_class.intent(intent_name, handler_bass_class_double, &intent_block)

      expect(described_class.class_variable_get(:@@handlers)["IntentName"]).to eq handler_class
    end
  end

  describe '.handle' do
    it 'builds an Alexa Request and handles it' do
      request = double(:request, body: StringIO.new("{}"))
      alexa_request_wrapper = double(:"Ralyxa::RequestEntities::Request")

      expect(described_class).to receive_message_chain(:new, :handle)
      expect(alexa_request_wrapper).to receive(:new).with(request)

      described_class.handle(request, alexa_request_wrapper)
    end
  end

  describe '#handle' do
    it 'delegates evaluation of an intent proc to a handler' do
      intent_name   = "IntentName"
      handler       = class_double("Ralyxa::Handler")
      described_class.class_variable_set(:@@handlers, { "#{intent_name}" => handler })
      alexa_request = double(:alexa_request, intent_name: intent_name)

      expect(handler).to receive_message_chain(:new, :handle)

      described_class.new(alexa_request).handle
    end

    it 'warns if no handler exists for a given intent' do
      alexa_request = double(:alexa_request, intent_name: "NonExistentIntent")
      skill = described_class.new(alexa_request)

      expect(skill).to receive(:warn)

      skill.handle
    end
  end
end