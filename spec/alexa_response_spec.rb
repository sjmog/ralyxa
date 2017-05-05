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

      output_speech = { type: "PlainText", text: "Custom String" }
      custom_response = described_class.build(output_speech: output_speech)
      
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

      output_speech = { type: "SSML", ssml: "<speak>Hello World</speak>" }
      ssml_response = described_class.build(output_speech: output_speech)
      expect(ssml_response).to eq expected_response
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