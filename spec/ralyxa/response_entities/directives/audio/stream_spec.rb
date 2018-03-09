require_relative '../../../../spec_helper'

RSpec.describe Ralyxa::ResponseEntities::Directives::Audio::Stream do
  describe '#initialize' do
    it 'raises a Ralyxa::UnsecureUrlError if the url is not served over HTTPS and Ralyxa is configured to use secure URLs only' do
      Ralyxa.require_secure_urls = true

      expect{ described_class.new('http://localhost', 'token') }.to raise_error(Ralyxa::UnsecureUrlError, 'Audio streams must be served from at an SSL-enabled (HTTPS) endpoint. Your current stream url is: http://localhost')
    end
  end

  describe '#to_h' do
    context 'with expected_previous_token' do
      subject(:stream) { described_class.new('http://localhost', 'my-token', 100, 'my-previous-token') }

      it 'generates the expected hash' do
        expect(stream.to_h).to eq({ "url" => "http://localhost", "token" => "my-token", "offsetInMilliseconds" => 100, "expectedPreviousToken" => "my-previous-token" })
      end
    end

    context 'without expected_previous_token' do
      subject(:stream) { described_class.new('http://localhost', 'my-token', 100) }

      it 'generates the expected hash' do
        expect(stream.to_h).to eq({ "url" => "http://localhost", "token" => "my-token", "offsetInMilliseconds" => 100 })
      end
    end
  end

  describe '.as_hash' do
    context 'with expected_previous_token' do
      subject(:stream) { described_class.as_hash('http://localhost', 'my-token', 100, 'my-previous-token') }

      it 'generates the expected hash' do
        expect(stream.to_h).to eq({ "url" => "http://localhost", "token" => "my-token", "offsetInMilliseconds" => 100, "expectedPreviousToken" => "my-previous-token" })
      end
    end

    context 'without expected_previous_token' do
      subject(:stream) { described_class.as_hash('http://localhost', 'my-token', 100) }

      it 'generates the expected hash' do
        expect(stream.to_h).to eq({ "url" => "http://localhost", "token" => "my-token", "offsetInMilliseconds" => 100 })
      end
    end
  end
end