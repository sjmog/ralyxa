require 'ralyxa/response_entities/response'

RSpec.describe Ralyxa::ResponseEntities::Response do
  let(:output_speech) { { type: "PlainText", text: "Hello World" } }
  subject(:response)  { described_class.as_hash(output_speech: output_speech) }

  describe '.as_hash' do
    it 'returns an empty response if no options are provided' do
      expected_response = {
          version: "1.0",
          response: {
              shouldEndSession: false
          }
      }

      custom_response = described_class.as_hash({})

      expect(custom_response).to eq expected_response
    end

    it 'returns a hash response with a custom string if provided' do
      expected_response = {
        version: "1.0",
        response: {
          outputSpeech: {
            type: "PlainText",
            text: "Custom String"
          },
          shouldEndSession: false
        }
      }

      output_speech = { type: "PlainText", text: "Custom String" }
      custom_response = described_class.as_hash(output_speech: output_speech)
      
      expect(custom_response).to eq expected_response
    end

    it 'returns a hash response with a reprompt if provided' do
      expected_response = {
        version: "1.0",
        response: {
          outputSpeech: {
            type: "PlainText",
            text: "Custom String"
          },
          reprompt: {
            outputSpeech: {
              type: "PlainText",
              text: "Please say that again."
            },
          },
          shouldEndSession: false
        }
      }

      output_speech = { type: "PlainText", text: "Custom String" }
      reprompt = { outputSpeech: { type: "PlainText", text: "Please say that again." } }
      custom_response = described_class.as_hash(output_speech: output_speech, reprompt: reprompt)

      expect(custom_response).to eq expected_response
    end

    it 'can use SSML if provided' do
      expected_response = {
        version: "1.0",
        response: {
          outputSpeech: {
            type: "SSML",
            ssml: "<speak>Hello World</speak>"
          },
          shouldEndSession: false
        }
      }

      output_speech = { type: "SSML", ssml: "<speak>Hello World</speak>" }
      ssml_response = described_class.as_hash(output_speech: output_speech)
      expect(ssml_response).to eq expected_response
    end

    it 'can use SSML for reprompt if provided' do
      expected_response = {
        version: "1.0",
        response: {
          outputSpeech: {
            type: "SSML",
            ssml: "<speak>Hello World</speak>"
          },
          reprompt: {
            outputSpeech: {
              type: "SSML",
              text: "<speak>Please say that again.</speak>"
            },
          },
          shouldEndSession: false
        }
      }

      output_speech = { type: "SSML", ssml: "<speak>Hello World</speak>" }
      reprompt = { outputSpeech: { type: "SSML", text: "<speak>Please say that again.</speak>" } }
      ssml_response = described_class.as_hash(output_speech: output_speech, reprompt: reprompt)
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
          },
          shouldEndSession: false
        }
      }

      session_response = described_class.as_hash(output_speech: output_speech, session_attributes: { sessionKey: "Session Value" })
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

      end_session_response = described_class.as_hash(output_speech: output_speech, end_session: true)
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
          },
          shouldEndSession: false
        }
      }

      start_over_response = described_class.as_hash(output_speech: output_speech, start_over: true)
      expect(start_over_response).to eq expected_response
    end

    it 'returns a minimal hash response otherwise' do
      minimal_response = { 
        version: "1.0",
        response: {
          outputSpeech: {
              type: "PlainText",
              text: "Hello World"
            },
            shouldEndSession: false
        }
      }
      
      expect(response).to eq minimal_response
    end
  end
end
