require 'ralyxa/request_entities/request'

RSpec.describe Ralyxa::RequestEntities::Request, vcr: true do
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

  describe 'request verification' do
    before :each do
      Ralyxa.configure do |config|
        config.validate_requests = true
      end

      Timecop.freeze(Time.local(2017,11,20,8,45,05))
    end

    after :each do

      Timecop.return
    end

    let(:valid_env) { { "HTTP_SIGNATURECERTCHAINURL" => 'https://s3.amazonaws.com/echo.api/echo-api-cert-5.pem', "HTTP_SIGNATURE" => "jJsLfPdMlcILlbOpGR2PLbJyb+CJrsAHgATg34UB5zyCYkHqRJvNDlJmxHar76B10Bk7UFJOWue4Fo772W0/cVJREK3HdqLnUNvJ9Yn2gs9ZLZQKQHFDysvo+0bKXA60Fi7RyF/O21m5i/u+LJlhNs3pkiOSUgXUmbST2cECpkG5yZWch7sgl8EEjk94FUy1s7gfCdT2Y4f4UGafQ5CJNtuEXCCaw0uu9NOY/RGBY1Gv+COmTlppvFLtFNqRbl9tJ7nSF44fcSIEPdJHoVDQ7FxdsbZopoZbsApNTHXXQun3+HuPYZG2kwiZ5Bt2z5F8WhbsdaplAB6CUltHVRsngQ==" } }
    let(:valid_body) { double(:body, read: " {\"session\": \n{\"sessionId\":\"SessionId.1cfa16c1-9794-4e44-9358-a009f0a6ea1c\",\"application\":{\"applicationId\":\"amzn1.ask.skill.f5e6173c-8f7a-4c51-85e8-275e52d9443b\"},\"attributes\":{},\"user\":{\"userId\":\"amzn1.ask.account.AFLKBJN4MUE2INQZPMXA2EQFB7ABENF646BL4526SWH7DQNKBVANCPKU4SMWN7ZJEOWIN3RSTZ3L2IJBDGBICRWVBADLN62UB6HNWA4VK2MCZD3DCNOZ6USQDZZSQFD2GRKUC4V5YWPYXJFILKLVEA7IJB2MY4ILWEJ3TC6MG7VQVFHK7PE6VH5KT2QUPWH4KPYOT6EY4DDWEBY\",\"accessToken\":null},\"new\":true},\n\"request\":\n{\"intent\":{\"name\":\"PlayAudio\",\"slots\":{}},\"requestId\":\"EdwRequestId.edb164fe-5dd1-4fb1-984b-bba5f0d2ee6d\",\"type\":\"IntentRequest\",\"locale\":\"en-GB\",\"timestamp\":\"2017-11-20T08:45:02Z\"},\"context\":{\"AudioPlayer\":{\"playerActivity\":\"IDLE\"},\"System\":{\"application\":{\"applicationId\":\"amzn1.ask.skill.f5e6173c-8f7a-4c51-85e8-275e52d9443b\"},\"user\":{\"userId\":\"amzn1.ask.account.AFLKBJN4MUE2INQZPMXA2EQFB7ABENF646BL4526SWH7DQNKBVANCPKU4SMWN7ZJEOWIN3RSTZ3L2IJBDGBICRWVBADLN62UB6HNWA4VK2MCZD3DCNOZ6USQDZZSQFD2GRKUC4V5YWPYXJFILKLVEA7IJB2MY4ILWEJ3TC6MG7VQVFHK7PE6VH5KT2QUPWH4KPYOT6EY4DDWEBY\"},\"device\":{\"supportedInterfaces\":{}}}},\"version\":\"1.0\"}", rewind: nil) }
    let(:valid_request) { double(:request, env: valid_env, body: valid_body) }

    let(:invalid_env) { { "HTTP_SIGNATURECERTCHAINURL" => 'http://bad.example', "HTTP_SIGNATURE" => 'invalid' } }
    let(:invalid_body) { double(:body, read: '{ "invalid": true }', rewind: nil) }
    let(:invalid_request) { double(:request, env: invalid_env, body: invalid_body) }

    it 'verifies valid requests' do
      expect(described_class.new(valid_request)).to be_a(described_class)
    end

    it 'raises an error for invalid requests' do
      expect{
        described_class.new(invalid_request)
      }.to raise_error(AlexaVerifier::InvalidCertificateURIError, "Invalid certificate URI : URI scheme must be 'https'. Got: 'http'.")
    end
  end

  private

  def stub_sinatra_request(request_json)
    original_request_body = StringIO.new(request_json)
    double("Sinatra::Request", body: original_request_body, env: {})
  end
end