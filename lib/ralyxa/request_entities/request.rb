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

      def initialize(original_request, user_class = Ralyxa::RequestEntities::User)
        @request = JSON.parse(original_request.body.read)
        @user = user_class.build(@request)

        validate_request(original_request) if Ralyxa.configuration.validate_requests?
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

      def session_attribute(attribute_name)
        @request['session']['attributes'][attribute_name]
      end

      private

      def intent_request?
        @request['request']['type'] == INTENT_REQUEST_TYPE
      end

      def validate_request(request)
        AlexaVerifier.valid!(request)
      end
    end
  end
end
