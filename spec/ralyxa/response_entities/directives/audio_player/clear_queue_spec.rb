require_relative '../../../../spec_helper'

RSpec.describe Ralyxa::ResponseEntities::Directives::AudioPlayer::ClearQueue do
  describe 'constants' do
    it 'has the expected constant values' do
      expect(described_class::CLEAR_ENQUEUED).to eq('CLEAR_ENQUEUED')
      expect(described_class::CLEAR_ALL).to eq('CLEAR_ALL')
    end
  end

  describe '#to_h' do
    it 'generates the expected hash' do
      expect(described_class.new.to_h).to eq({ "type" => "AudioPlayer.ClearQueue", "clearBehavior" => "CLEAR_ENQUEUED" })
    end
  end

  describe '.as_hash' do
    context 'without a behaviour' do
      it 'generates the expected hash' do
        expect(described_class.as_hash).to eq({ "type" => "AudioPlayer.ClearQueue", "clearBehavior" => "CLEAR_ENQUEUED" })
      end
    end

    context 'with a behaviour' do
      it 'generates the expected hash' do
        expect(described_class.as_hash('FOO')).to eq({ "type" => "AudioPlayer.ClearQueue", "clearBehavior" => "FOO" })
      end
    end
  end
end