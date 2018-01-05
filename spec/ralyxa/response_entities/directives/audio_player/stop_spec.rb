require_relative '../../../../spec_helper'

RSpec.describe Ralyxa::ResponseEntities::Directives::AudioPlayer::Stop do
  describe '#to_h' do
    it 'generates the expected hash' do
      expect(described_class.new.to_h).to eq({ "type" => "AudioPlayer.Stop" })
    end
  end

  describe '.as_hash' do
    it 'generates the expected hash' do
      expect(described_class.as_hash).to eq({ "type" => "AudioPlayer.Stop" })
    end
  end
end
