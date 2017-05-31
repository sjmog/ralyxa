require 'ralyxa/request_entities/user'

RSpec.describe Ralyxa::RequestEntities::User do
  describe '.build' do
    it 'builds a user object from a request' do
      ralyxa_request = {
        "session" => {
          "user" => {
            "userId" => "someUserId",
            "accessToken" => "someAccessToken"
          }
        }
      }
      expect(described_class).to receive(:new).with(id: "someUserId", access_token: "someAccessToken")
      described_class.build(ralyxa_request)
    end

    it 'handles malformed requests' do
      ralyxa_request = {}

      expect { described_class.build(ralyxa_request) }.not_to raise_error
    end
  end

  describe '#id' do
    it 'returns the given userId' do
      user = described_class.new(id: "someUserId")
      expect(user.id).to eq "someUserId"
    end

    it 'is a required parameter' do
      expect { described_class.new }.to raise_error ArgumentError
    end
  end

  describe '#access_token' do
    it 'returns the given accessToken' do
      user = described_class.new(id: "someUserId", access_token: "someAccessToken")
      expect(user.access_token).to eq "someAccessToken"
    end

    it 'is nil if the accessToken does not exist' do
      user = described_class.new(id: "someUserId")
      expect(user.access_token).to be_nil
    end
  end

  describe '#access_token_exists?' do
    it 'is true if the user was given an accessToken' do
      user_with_access_token = described_class.new(id: "someUserId", access_token: "someAccessToken")
      expect(user_with_access_token.access_token_exists?).to be true
    end

    it 'is false otherwise' do
      user_without_access_token = described_class.new(id: "someUserId")
      expect(user_without_access_token.access_token_exists?).to be false
    end
  end
end