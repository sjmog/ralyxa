require_relative '../../../spec_helper'

RSpec.describe Ralyxa::ResponseEntities::Directives::AudioPlayer do
  let(:card) { Ralyxa::ResponseEntities::Card.as_hash('Hello World', 'This is a test', 'https://placehold.it/100', 'https://placehold.it/200') }

  describe '.play' do
    context 'with only the required attributes' do
      it 'generates the expected json' do
        expect(described_class.play('http://localhost', 'token')).to eq("{\"version\":\"1.0\",\"response\":{\"directives\":[{\"type\":\"AudioPlayer.Play\",\"playBehavior\":\"REPLACE_ALL\",\"audioItem\":{\"stream\":{\"url\":\"http://localhost\",\"token\":\"token\",\"offsetInMilliseconds\":0}}}],\"shouldEndSession\":false}}")
      end
    end

    context 'with all attributes' do
      it 'generates the expected json' do
        expect(described_class.play('http://localhost', 'token', speech: 'My Radio', card: card, offset_in_milliseconds: 100, expected_previous_token: 'previous', behaviour: Ralyxa::ResponseEntities::Directives::AudioPlayer::Play::ENQUEUE)).to eq('{"version":"1.0","response":{"outputSpeech":{"type":"PlainText","text":"My Radio"},"card":{"type":"Standard","title":"Hello World","text":"This is a test","image":{"smallImageUrl":"https://placehold.it/100","largeImageUrl":"https://placehold.it/200"}},"directives":[{"type":"AudioPlayer.Play","playBehavior":"ENQUEUE","audioItem":{"stream":{"url":"http://localhost","token":"token","offsetInMilliseconds":100,"expectedPreviousToken":"previous"}}}],"shouldEndSession":false}}')
      end
    end
  end

  describe '.play_later' do
    context 'with only the required attributes' do
      it 'generates the expected json' do
        expect(described_class.play_later('http://localhost', 'token')).to eq("{\"version\":\"1.0\",\"response\":{\"directives\":[{\"type\":\"AudioPlayer.Play\",\"playBehavior\":\"REPLACE_ENQUEUED\",\"audioItem\":{\"stream\":{\"url\":\"http://localhost\",\"token\":\"token\",\"offsetInMilliseconds\":0}}}],\"shouldEndSession\":false}}")
      end
    end

    context 'with all attributes' do
      it 'generates the expected json' do
        expect(described_class.play_later('http://localhost', 'token', speech: 'My Radio', card: card, offset_in_milliseconds: 100, expected_previous_token: 'previous', behaviour: Ralyxa::ResponseEntities::Directives::AudioPlayer::Play::ENQUEUE)).to eq('{"version":"1.0","response":{"outputSpeech":{"type":"PlainText","text":"My Radio"},"card":{"type":"Standard","title":"Hello World","text":"This is a test","image":{"smallImageUrl":"https://placehold.it/100","largeImageUrl":"https://placehold.it/200"}},"directives":[{"type":"AudioPlayer.Play","playBehavior":"ENQUEUE","audioItem":{"stream":{"url":"http://localhost","token":"token","offsetInMilliseconds":100,"expectedPreviousToken":"previous"}}}],"shouldEndSession":false}}')
      end
    end
  end

  describe '.stop' do
    context 'without speech' do
      it 'generates the expected json' do
        expect(described_class.stop).to eq("{\"version\":\"1.0\",\"response\":{\"directives\":[{\"type\":\"AudioPlayer.Stop\"}],\"shouldEndSession\":false}}")
      end
    end

    context 'with speech' do
      it 'with speech generates the expected json' do
        expect(described_class.stop(speech: 'My Radio', card: card)).to eq('{"version":"1.0","response":{"outputSpeech":{"type":"PlainText","text":"My Radio"},"card":{"type":"Standard","title":"Hello World","text":"This is a test","image":{"smallImageUrl":"https://placehold.it/100","largeImageUrl":"https://placehold.it/200"}},"directives":[{"type":"AudioPlayer.Stop"}],"shouldEndSession":false}}')
      end
    end
  end

  describe '.clear_queue' do
    context 'with only the default attributes' do
      it 'generates the expected json' do
        expect(described_class.clear_queue).to eq("{\"version\":\"1.0\",\"response\":{\"directives\":[{\"type\":\"AudioPlayer.ClearQueue\",\"clearBehavior\":\"CLEAR_ALL\"}],\"shouldEndSession\":false}}")
      end
    end

    context 'with all attributes' do
      it 'generates the expected json' do
        expect(described_class.clear_queue(speech: 'My Radio', card: card, behaviour: Ralyxa::ResponseEntities::Directives::AudioPlayer::ClearQueue::CLEAR_ENQUEUED)).to eq('{"version":"1.0","response":{"outputSpeech":{"type":"PlainText","text":"My Radio"},"card":{"type":"Standard","title":"Hello World","text":"This is a test","image":{"smallImageUrl":"https://placehold.it/100","largeImageUrl":"https://placehold.it/200"}},"directives":[{"type":"AudioPlayer.ClearQueue","clearBehavior":"CLEAR_ENQUEUED"}],"shouldEndSession":false}}')
      end
    end
  end
end
