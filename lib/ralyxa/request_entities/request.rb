require 'json'
require 'forwardable'
require 'alexa_verifier'
require_relative './user'

module Ralyxa
  module RequestEntities
    class Request
      extend Forwardable
      INTENT_REQUEST_TYPE = 'IntentRequest'.freeze

      def_delegator :@user, :id, :user_id
      def_delegator :@user, :access_token, :user_access_token
      def_delegator :@user, :access_token_exists?, :user_access_token_exists?

      attr_reader :request

      def initialize(original_request, user_class = Ralyxa::RequestEntities::User)
        validate_request(original_request) if Ralyxa.configuration.validate_requests?

        @request = JSON.parse(original_request.body.read)
        attempt_to_rewind_request_body(original_request)

        @user = user_class.build(@request)
      end

      def intent_name
        return @request['request']['type'] unless intent_request?
        @request['request']['intent']['name']
      end

      def slot_value(slot_name)
        @request['request']['intent']['slots'][slot_name]['value']
      end

      def new_session?
        @request['session']['new']
      end

      def session_attributes
        @request['session']['attributes']
      end

      def session_attribute(attribute_name)
        session_attributes[attribute_name]
      end

      private

      def intent_request?
        @request['request']['type'] == INTENT_REQUEST_TYPE
      end

      def validate_request(request)
        AlexaVerifier.valid!(request)
      end

      def attempt_to_rewind_request_body(original_request)
        original_request.body&.rewind
      end
    end
  end
end
