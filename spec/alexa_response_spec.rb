require 'alexa/response'

RSpec.describe Alexa::Response do
  subject(:response) { described_class.build }

  describe '.build' do
    it 'returns a JSON response with a custom string if provided' do
      expected_response = {
        version: "1.0",
        response: {
          outputSpeech: {
              type: "PlainText",
              text: "Custom String"
            }
        }
      }.to_json

      custom_response = described_class.build(response_text: "Custom String")
      expect(custom_response).to eq expected_response
    end

    it 'can use SSML if provided' do
      expected_response = {
        version: "1.0",
        response: {
          outputSpeech: {
            type: "SSML",
            ssml: "<speak>Hello World</speak>"
          }
        }
      }.to_json

      ssml_response = described_class.build(response_text: "<speak>Hello World</speak>", ssml: true)
      expect(ssml_response).to eq expected_response
    end

    it 'limits the outputSpeech to 140 characters' do
      over_length_string = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque interdum rutrum sodales. Nullam mattis fermentum libero, noon volutpat."
      expect(over_length_string).to receive(:slice).with(0, 140)
      
      described_class.build(response_text: over_length_string)
    end

    it 'returns a JSON response with session data if provided' do
      expected_response = { 
        version: "1.0",
        sessionAttributes: {
          sessionKey: "Session Value"
        },
        response: {
          outputSpeech: {
              type: "PlainText",
              text: "Hello World"
            }
        }
      }.to_json

      session_response = described_class.build(session_attributes: { sessionKey: "Session Value" })
      expect(session_response).to eq expected_response
    end

    it 'returns a JSON response with an endSessionRequest if provided' do
      expected_response = {
        version: "1.0",
        response: {
          outputSpeech: {
            type: "PlainText",
            text: "Hello World"
          },
          shouldEndSession: true
        }
      }.to_json

      end_session_response = described_class.build(end_session: true)
      expect(end_session_response).to eq expected_response
    end

    it 'returns a JSON response that "starts over" by clearing the Session Attributes if provided' do
      expected_response = {
        version: "1.0",
        sessionAttributes: {},
        response: {
          outputSpeech: {
            type: "PlainText",
            text: "Hello World"
          }
        }
      }.to_json

      start_over_response = described_class.build(start_over: true)
      expect(start_over_response).to eq expected_response
    end

    it 'returns a minimal JSON response otherwise' do
      minimal_response = { 
        version: "1.0",
        response: {
          outputSpeech: {
              type: "PlainText",
              text: "Hello World"
            }
        }
      }.to_json
      
      expect(response).to eq minimal_response
    end
  end
end