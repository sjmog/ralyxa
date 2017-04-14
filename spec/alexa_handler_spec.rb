require 'alexa/handler'

RSpec.describe Alexa::Handler do
  let(:intent_proc) { Proc.new { self.class } }
  subject(:handler) { described_class.new(&intent_proc) }

  describe '#handle' do
    it 'executes an intent Proc bound to the scope of the current class' do
      expect(handler.handle).to eq described_class
    end
  end
end