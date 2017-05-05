require 'alexa/response'

RSpec.describe Alexa::Response do
  let(:output_speech) { { type: "PlainText", text: "Hello World" } }
  subject(:response)  { described_class.hash(output_speech: output_speech) }

  describe '.hash' do
    it 'returns a hash response with a custom string if provided' do
      expected_response = {
        version: "1.0",
        response: {
          outputSpeech: {
              type: "PlainText",
              text: "Custom String"
            }
        }
      }

      output_speech = { type: "PlainText", text: "Custom String" }
      custom_response = described_class.hash(output_speech: output_speech)
      
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
      }

      output_speech = { type: "SSML", ssml: "<speak>Hello World</speak>" }
      ssml_response = described_class.hash(output_speech: output_speech)
      expect(ssml_response).to eq expected_response
    end

    it 'returns a hash response with session data if provided' do
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
      }

      session_response = described_class.hash(output_speech: output_speech, session_attributes: { sessionKey: "Session Value" })
      expect(session_response).to eq expected_response
    end

    it 'returns a hash response with an endSessionRequest if provided' do
      expected_response = {
        version: "1.0",
        response: {
          outputSpeech: {
            type: "PlainText",
            text: "Hello World"
          },
          shouldEndSession: true
        }
      }

      end_session_response = described_class.hash(output_speech: output_speech, end_session: true)
      expect(end_session_response).to eq expected_response
    end

    it 'returns a hash response that "starts over" by clearing the Session Attributes if provided' do
      expected_response = {
        version: "1.0",
        sessionAttributes: {},
        response: {
          outputSpeech: {
            type: "PlainText",
            text: "Hello World"
          }
        }
      }

      start_over_response = described_class.hash(output_speech: output_speech, start_over: true)
      expect(start_over_response).to eq expected_response
    end

    it 'returns a minimal hash response otherwise' do
      minimal_response = { 
        version: "1.0",
        response: {
          outputSpeech: {
              type: "PlainText",
              text: "Hello World"
            }
        }
      }
      
      expect(response).to eq minimal_response
    end
  end
end