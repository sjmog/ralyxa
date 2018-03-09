require_relative '../../../../spec_helper'

RSpec.describe Ralyxa::ResponseEntities::Directives::AudioPlayer::Play do
  describe 'constants' do
    it 'has the expected constant values' do
      expect(described_class::REPLACE_ALL).to eq('REPLACE_ALL')
      expect(described_class::ENQUEUE).to eq('ENQUEUE')
      expect(described_class::CLEAR_ENQUEUE).to eq('CLEAR_ENQUEUE')
    end
  end

  describe '#to_h' do
    subject(:play) { described_class.new(Ralyxa::ResponseEntities::Directives::Audio::Stream.new('http://localhost', 'token')) }

    it 'generates the expected hash' do
      expect(play.to_h).to eq({ "type" => "AudioPlayer.Play", "playBehavior" => "REPLACE_ALL", "audioItem" => { "stream" => { "url" => "http://localhost", "token" => "token", "offsetInMilliseconds" => 0 } } })
    end
  end

  describe '.as_hash' do
    context 'without a behaviour' do
      subject(:play) { described_class.new(Ralyxa::ResponseEntities::Directives::Audio::Stream.new('http://localhost', 'token')) }

      it 'generates the expected hash' do
        expect(play.to_h).to eq({ "type" => "AudioPlayer.Play", "playBehavior" => "REPLACE_ALL", "audioItem" => { "stream" => { "url" => "http://localhost", "token" => "token", "offsetInMilliseconds" => 0 } } })
      end
    end

    context 'with a behaviour' do
      subject(:play) { described_class.new(Ralyxa::ResponseEntities::Directives::Audio::Stream.new('http://localhost', 'token'), 'FOO') }

      it 'generates the expected hash' do
        expect(play.to_h).to eq({ "type" => "AudioPlayer.Play", "playBehavior" => "FOO", "audioItem" => { "stream" => { "url" => "http://localhost", "token" => "token", "offsetInMilliseconds" => 0 } } })
      end
    end
  end
end