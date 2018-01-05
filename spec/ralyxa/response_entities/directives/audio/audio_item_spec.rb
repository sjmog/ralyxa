require_relative '../../../../spec_helper'

RSpec.describe Ralyxa::ResponseEntities::Directives::Audio::AudioItem do
  subject(:audio_item) { described_class.new(Ralyxa::ResponseEntities::Directives::Audio::Stream.new('http://localhost', 'token')) }

  describe '#to_h' do
    it 'generates the expected hash' do
      expect(audio_item.to_h).to eq({ "stream" => { "url" => "http://localhost", "token" => "token", "offsetInMilliseconds" => 0 } })
    end
  end

  describe '.as_hash' do
    it 'generates the expected hash' do
      expect(
        described_class.as_hash(
          Ralyxa::ResponseEntities::Directives::Audio::Stream.new(
            'http://localhost',
            'token')
        )
      ).to eq({ "stream" => { "url" => "http://localhost", "token" => "token", "offsetInMilliseconds" => 0 } })
    end
  end
end