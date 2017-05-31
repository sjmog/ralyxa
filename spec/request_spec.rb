require 'ralyxa/request_entities/request'

RSpec.describe Ralyxa::RequestEntities::Request do
  describe '#intent_name' do
    it 'returns the IntentName from the request' do
      stubbed_request = stub_sinatra_request({  
        "request": {
          "type": "IntentRequest",
          "intent": {
            "name": "IntentName",
            "slots": {
              "SlotName": {
                "name": "SlotName",
                "value": "10"
              }
            }
          }
        }
      }.to_json)

      expect(described_class.new(stubbed_request).intent_name).to eq "IntentName"
    end

    it 'returns the IntentName if the request is a built-in request' do
      stubbed_request = stub_sinatra_request({  
        "request": {
          "type": "LaunchRequest"
        }
      }.to_json)

      expect(described_class.new(stubbed_request).intent_name).to eq "LaunchRequest"
    end
  end

  describe '#slot_value' do
    it 'returns the value for a specific slot' do
      stubbed_request = stub_sinatra_request({
        "request": {
          "type": "IntentRequest",
          "intent": {
            "name": "IntentName",
            "slots": {
              "SlotName": {
                "name": "SlotName",
                "value": "10"
              }
            }
          }
        }
      }.to_json)

      expect(described_class.new(stubbed_request).slot_value("SlotName")).to eq "10"
    end
  end

  describe '#new_session?' do
    it 'is true if this is a new session' do
      stubbed_request = stub_sinatra_request({
        "session": {
          "sessionId": "id_string",
          "application": {
            "applicationId": "id_string"
          },
          "new": true
        }
      }.to_json)

      expect(described_class.new(stubbed_request).new_session?).to be true
    end

    it 'is false otherwise' do
      stubbed_request = stub_sinatra_request({
        "session": {
          "sessionId": "id_string",
          "new": false
        }
      }.to_json)

      expect(described_class.new(stubbed_request).new_session?).to be false
    end
  end

  describe '#session_attribute' do
    it 'returns the value for a specified session attribute' do
      stubbed_request = stub_sinatra_request({
        "session": {
          "sessionId": "id_string",
          "attributes": {
            "movieTitle": "titanic"
          }
        }
      }.to_json)

      expect(described_class.new(stubbed_request).session_attribute("movieTitle")).to eq "titanic"
    end
  end

  context 'delegations' do
    let(:stubbed_request) do
      stub_sinatra_request({
        "session": {
          "user": {
            "userId": "id_string",
            "accessToken": "access_token"
          }
        }
      }.to_json)
    end
    let(:user) { double(:ralyxa_user) }
    let(:user_class) { double(:"Ralyxa::User", build: user) }

    describe '#user_id' do
      it 'delegates to a user object' do
        expect(user).to receive(:id)
        described_class.new(stubbed_request, user_class).user_id
      end
    end

    describe '#user_access_token' do
      it 'delegates to a user object' do
        expect(user).to receive(:access_token)
        described_class.new(stubbed_request, user_class).user_access_token
      end
    end

    describe '#user_access_token_exists?' do
      it 'delegates to a user object' do
        expect(user).to receive(:access_token_exists?)
        described_class.new(stubbed_request, user_class).user_access_token_exists?
      end
    end
  
  end

  private

  def stub_sinatra_request(request_json)
    original_request_body = StringIO.new(request_json)
    double("Sinatra::Request", body: original_request_body)
  end
end